require "scorched/helpers"

module Scorched
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

      @cache = nil
    end

    def image(height)
      @cache ||= begin
        image = Ray::Image.new [width, height]

        Ray::ImageTarget.new(image) do |target|
         each_with_index do |y, x|
           target.draw Ray::Polygon.line([x, height], [x, height - y], 1, color)
         end

         target.update
        end

        Ray::Sprite.new image, at: [0, 0]
      end
    end
  end
end
