include Java

import java.awt.Transparency

module ScorchedEarth
  module Renders
    class Array
      attr_reader :terrain, :_cache

      def initialize(terrain, _cache = {})
        @terrain = terrain
        @_cache  = _cache
      end

      def call(graphics, color_palette)
        image = cache(key) { to_image(graphics, color_palette) }

        graphics.draw_image image, 0, 0, nil
      end

      private

      def to_image(graphics, color_palette)
        height = graphics.destination.height
        color  = color_palette.get(terrain.class.name)

        image = graphics
                .get_device_configuration
                .create_compatible_image width, height, Transparency::TRANSLUCENT

        terrain.each_with_index do |y, x|
          image.graphics.tap do |image_graphics|
            image_graphics.set_color color
            image_graphics.draw_line x, height - y, x, height
          end
        end

        image
      end

      def key
        terrain.reduce(&:+)
      end

      def width
        terrain.size
      end

      def cache(key)
        _cache[key] ||= begin
          yield
        end
      end
    end
  end
end
