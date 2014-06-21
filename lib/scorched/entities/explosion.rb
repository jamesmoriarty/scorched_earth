require_relative "./entity"

module Scorched
  class Explosion < Entity
    attr_accessor :radius

    def radius
      @radius ||= 10
    end

    def update
      @radius += 10
      destroy if radius > 50
    end

    def render(win, height)
      win.draw Ray::Polygon.circle([x, height - y], radius, Ray::Color.yellow)
    end
  end
end
