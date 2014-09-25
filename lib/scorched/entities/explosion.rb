require "entities/entity"

module Scorched
  class Explosion < Entity
    attr_accessor :radius

    def initialize(*args)
      super

      @radius = 10
    end

    def update
      @radius += 10
      destroy if radius > 50
    end

    def render(win, height)
      win.draw Ray::Polygon.circle([x, height - y], radius, Ray::Color.new(255, 255, 204))
    end
  end
end
