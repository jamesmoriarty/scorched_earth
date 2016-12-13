include Java

import java.awt.BasicStroke

module ScorchedEarth
  module Renders
    class Mouse
      attr_reader :mouse, :player

      def initialize(mouse, player)
        @mouse  = mouse
        @player = player
      end

      def call(graphics, color_palette)
        return unless mouse.x && mouse.y

        color  = color_palette.get(player.x)
        height = graphics.destination.height

        graphics.set_color color
        graphics.setStroke BasicStroke.new 3
        graphics.draw_line mouse.x, mouse.y, player.x, height - player.y
      end
    end
  end
end
