require_relative "./entity"

module Scorched
  class Shot < Entity
    def radius
      30
    end

    def update
      move
      @velocity_y -= 0.5
      @angle       = Math.angle(velocity_y, velocity_x)
    end

    def render(win, height)
      x1, y1 = x, height - y
      x2, y2 = x1 + Math.offsetX(angle, 10), y1 + Math.offsetY(angle, 10)
      win.draw Ray::Polygon.line([x1, y1], [x2, y2], 2, Ray::Color.new(255, 255, 204))
    end

    def destroy
      super

      Explosion.create(x: x, y: y)
    end
  end
end
