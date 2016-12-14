include Java

import java.awt.BasicStroke

require 'scorched_earth/helpers'

module ScorchedEarth
  module Renders
    class Shot
      include Helpers

      attr_reader :shot

      def initialize(shot)
        @shot = shot
      end

      def call(graphics, *_args)
        height = graphics.destination.height
        y1     = height - shot.y
        y2     = y1 + offset_y(degrees, length)

        graphics.setStroke BasicStroke.new 3
        graphics.set_color Color::LIGHT_GRAY
        graphics.draw_line x1 + 2, y1 + 2, x2 + 2, y2 + 2
        graphics.setStroke BasicStroke.new 3
        graphics.set_color Color::WHITE
        graphics.draw_line x1, y1, x2, y2
      end

      private

      def x1
        shot.x
      end

      def x2
        x1 + offset_x(degrees, length)
      end

      def degrees
        angle shot.velocity_y, shot.velocity_x
      end

      def length
        10
      end

      def width
        3
      end
    end
  end
end
