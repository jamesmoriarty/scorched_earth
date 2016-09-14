require "scorched/entity"

module Scorched
  class Shot
    include Entity

    GRAVITY = 2000

    def update(delta)
      @velocity_y -= GRAVITY * delta
      @x          += velocity_x * delta
      @y          += velocity_y * delta
    end

    def draw(win)
      width, height = *win.size

      win.draw Ray::Polygon.circle([x, height - y], 5, Ray::Color.black)
    end
  end
end
