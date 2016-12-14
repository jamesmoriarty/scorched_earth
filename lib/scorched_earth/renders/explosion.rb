module ScorchedEarth
  module Renders
    class Explosion
      attr_reader :explosion

      def initialize(explosion)
        @explosion = explosion
      end

      def call(graphics, *_args)
        height = graphics.destination.height
        y      = height - explosion.y - radius / 2

        graphics.set_color color
        graphics.fill_oval x, y, radius, radius
      end

      private

      def color
        Color.white
      end

      def radius
        explosion.radius
      end

      def x
        explosion.x - radius / 2
      end
    end
  end
end
