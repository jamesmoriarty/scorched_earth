require "game_object"

module Scorched
  class Entity < GameObject
    attr_accessor :x, :y, :velocity_x, :velocity_y, :angle, :terrain

    def initialize(x: 0, y: 0, velocity_x: 0, velocity_y: 0, angle: 0, terrain: nil)
      @x, @y, @velocity_x, @velocity_y, @angle, @terrain = x, y, velocity_x, velocity_y, angle, terrain
    end

    def update
      move
    end

    def move
      @x += velocity_x
      @y += velocity_y
    end
  end
end
