require 'scorched_earth/helpers'

include Java

import java.awt.Transparency

module ScorchedEarth
  class Terrain < Array
    include Helpers

    attr_reader :color, :height

    def initialize(width, height, cycles, color)
      @color  = color
      @height = height

      super(width) do |index|
        Math.sin(index.to_f / width * cycles) * height / 4 + (height / 4)
      end
    end

    def width
      size
    end

    def draw(graphics)
      graphics.draw_image cache { _draw(graphics) }, 0, 0, nil
    end

    def _draw(graphics)
      image = graphics
              .get_device_configuration
              .create_compatible_image width, height, Transparency::TRANSLUCENT

      each_with_index do |y, x|
        image.graphics.tap do |image_graphics|
          image_graphics.set_color color
          image_graphics.draw_line x, height - y, x, height
        end
      end

      image
    end

    def bite(center_x, radius, center_y = self[center_x])
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

    private

    def cache
      @cache ||= begin
        yield
      end
    end

    def clear_cache!
      @cache = nil
    end
  end
end
