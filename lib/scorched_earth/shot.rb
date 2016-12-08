include Java

import java.awt.BasicStroke
import java.awt.Color

require 'scorched_earth/helpers'

module ScorchedEarth
  class Shot
    include Helpers

    attr_reader :x, :y, :velocity_x, :velocity_y

    def initialize(x, y, velocity_x, velocity_y)
      @x          = x
      @y          = y
      @velocity_x = velocity_x
      @velocity_y = velocity_y
    end

    def update(delta)
      @velocity_y -= gravity * delta
      @x          += velocity_x * delta
      @y          += velocity_y * delta
    end

    def draw(graphics)
      height  = graphics.destination.height
      degrees = angle velocity_y, velocity_x
      x1      = x
      y1      = height - y
      x2      = x1 + offset_x(degrees, length)
      y2      = y1 + offset_y(degrees, length)

      graphics.setStroke BasicStroke.new 3
      graphics.set_color Color::LIGHT_GRAY
      graphics.draw_line x1 + 2, y1 + 2, x2 + 2, y2 + 2
      graphics.setStroke BasicStroke.new 3
      graphics.set_color Color::WHITE
      graphics.draw_line x1, y1, x2, y2
    end

    def length
      10
    end

    def width
      3
    end

    def gravity
      2000
    end
  end
end
