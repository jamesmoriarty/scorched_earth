require "scorched/entity"

module Scorched
  class Shot
    include Entity
    include Helpers

    GRAVITY     = 2000
    LINE_LENGTH = 10
    LINE_WIDTH  = 2
    LINE_COLOR  = Ray::Color.black

    def update(delta)
      @velocity_y -= GRAVITY * delta
      @x          += velocity_x * delta
      @y          += velocity_y * delta
    end

    def draw(win)
      width, height = *win.size
      degrees       = angle(velocity_y, velocity_x)
      x1, y1        = x, height - y
      x2, y2        = x1 + offset_x(degrees, LINE_LENGTH), y1 + offset_y(degrees, LINE_LENGTH)

      win.draw Ray::Polygon.line([x1, y1], [x2, y2], LINE_WIDTH, LINE_COLOR)
    end
  end
end
