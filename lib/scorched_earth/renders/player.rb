module ScorchedEarth
  module Renders
    class Player
      attr_reader :player

      def initialize(player)
        @player = player
      end

      def call(graphics, color_palette)
        color  = color_palette.get(player.x)
        height = graphics.destination.height
        y      = height - player.y - radius / 2

        graphics.set_color color
        graphics.fill_oval x, y, radius, radius
      end

      private

      def x
        player.x - radius / 2
      end

      def radius
        25
      end
    end
  end
end
