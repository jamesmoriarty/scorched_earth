include Java

import java.awt.Color
import java.awt.BasicStroke
import java.awt.geom.GeneralPath

require 'scorched_earth/renders/trajectory'

module ScorchedEarth
  module Renders
    class Shot

      attr_reader :shot

      def initialize(shot)
        @shot = shot
      end

      def call(graphics, *_args)
        ScorchedEarth::Renders::Trajectory.new(shot.trajectory).call(graphics, *_args)
      end
    end
  end
end
