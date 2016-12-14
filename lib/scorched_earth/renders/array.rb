include Java

import java.awt.Transparency

module ScorchedEarth
  module Renders
    class Array
      module Cache
        def to_image(graphics, color_palette)
          cache(key) do
            super
          end
        end

        private

        def key
          array.join
        end

        def cache(key)
          @@cache      ||= {}

          if value = @@cache[key]
            return value
          else
            @@cache = {}
            @@cache[key] ||= begin
              yield
            end
          end
        end
      end

      prepend Cache

      attr_reader :array

      def initialize(array)
        @array  = array
      end

      def call(graphics, color_palette)
        graphics.draw_image to_image(graphics, color_palette), 0, 0, nil
      end

      private

      def to_image(graphics, color_palette)
        height = graphics.destination.height
        color  = color_palette.get(array.class.name)

        image = graphics
                .get_device_configuration
                .create_compatible_image width, height, Transparency::TRANSLUCENT

        array.each_with_index do |y, x|
          image.graphics.tap do |image_graphics|
            image_graphics.set_color color
            image_graphics.draw_line x, height - y, x, height
          end
        end

        image
      end

      def key
        array.reduce(&:+)
      end

      def width
        array.size
      end
    end
  end
end
