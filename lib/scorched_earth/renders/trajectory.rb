include Java

import java.awt.Color
import java.awt.BasicStroke
import java.awt.geom.GeneralPath

module ScorchedEarth
  module Renders
    class Trajectory
      attr_reader :trajectory

      def initialize(trajectory)
        @trajectory = trajectory
      end

      def call(graphics, *_args)
        height            = graphics.destination.height
        path              = GeneralPath.new GeneralPath::WIND_NON_ZERO
        first, *remaining = trajectory

        path.move_to first[0], height - first[1]

        remaining.each do |x, y|
          path.line_to x, height - y
        end

        graphics.set_stroke BasicStroke.new 3.0, BasicStroke::CAP_ROUND, BasicStroke::JOIN_ROUND, 10.0, [10.0].to_java(:float), 0.0
        graphics.set_color Color::WHITE

        graphics.draw path
      end
    end
  end
end
