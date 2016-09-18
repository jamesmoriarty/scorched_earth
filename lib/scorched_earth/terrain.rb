require "scorched_earth/helpers"

module ScorchedEarth
  class Terrain < Array
    include Helpers

    attr_reader :color

    def initialize(width, height, cycles, color)
      @color = color

      super(width) do |index|
        Math.sin(index.to_f / width * cycles) * height / 4 + (height / 4)
      end
    end

    def width
      size
    end

    def draw(win)
      width, height = *win.size

      win.draw image height
    end

    def bite(center_x, radius)
      center_y = self[center_x]

      circle(radius) do |offset_x, offset_y|
        x = center_x + offset_x
        y = self[x]
        next unless y
        z = offset_y * 2
        q = center_y - offset_y
        q = y if q > y

        self[x] = [y - z, q, 0].max
      end

      clear_cache!
    end

    def image(height)
      cache do
        image = Ray::Image.new [width, height]

        Ray::ImageTarget.new(image) do |target|
          target.clear Ray::Color.new(0, 0, 0, 0)

          each_with_index do |y, x|
            target.draw Ray::Polygon.line([x, height], [x, height - y], 1, color)
          end

          target.update
        end

        Ray::Sprite.new image, at: [0, 0]
      end
    end

    private

    def cache(&block)
      @cache ||= begin
        block.call
      end
    end

    def clear_cache!
      @cache = nil
    end
  end
end
