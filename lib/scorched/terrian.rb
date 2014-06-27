module Scorched
  class Terrian < Array
    alias :width :size

    def initialize(width, height, cycles)
      super(width) do |index|
        Math.sin(index.to_f / width.to_f * cycles.to_f) * height / 4 + (height / 4).to_i
      end
    end

    def render(win, height)
      win.draw sprite(height)
    end

    def sprite(height)
      @cache ||= begin
        image = Ray::Image.new [width, height]

        Ray::ImageTarget.new(image) do |target|
          each_with_index do |y, x|
            target.draw Ray::Polygon.line([x, height], [x, height - y], 1, Ray::Color.new(204, 204, 153))
          end

          target.update
        end

        Ray::Sprite.new(image, at: [0, 0])
      end
    end

    def deform(center_x, radius)
      center_y = self[center_x]

      Math.circle(radius) do |x_offset, y_offset|
        x = center_x + x_offset
        y = self[x]
        next unless y
        z = y_offset * 2
        q = center_y - y_offset
        q = y if q > y

        self[x] = [y - z, q, 0].max
      end

      @cache = nil
    end
  end
end
