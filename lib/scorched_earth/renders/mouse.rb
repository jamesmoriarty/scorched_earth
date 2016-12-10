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

      def call(graphics)
        return unless mouse.x && mouse.y

        height = graphics.destination.height

        graphics.set_color player.color
        graphics.setStroke BasicStroke.new 3
        graphics.draw_line mouse.x, mouse.y, player.x, height - player.y
      end
    end
  end
end
