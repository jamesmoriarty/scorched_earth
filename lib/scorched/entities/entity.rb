require_relative "../collection"

module Scorched
  class Entity
    include Collection

    attr_accessor :x, :y, :velocity_x, :velocity_y, :angle, :terrian

    def initialize(x: 0, y: 0, velocity_x: 0, velocity_y: 0, angle: 0, terrian: nil)
      @x, @y, @velocity_x, @velocity_y, @angle, @terrian = x, y, velocity_x, velocity_y, angle, terrian
    end

    def update
      move
    end

    def render(win, height)
    end

    def move
      @x += velocity_x
      @y += velocity_y
    end
  end
end
