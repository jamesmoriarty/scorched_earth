require "scorched/terrain"
require "scorched/player"

module Scorched
  class GameScene < Ray::Scene
    attr_reader :entities, :terrain

    def register
      add_hook :quit,                    method(:exit!)
      add_hook :key_press, key(:escape), method(:exit!)
    end

    def setup
      width, height = *window.size
      @entities = 2.times.map { Player.new(rand(width), Ray::Color.new(rand(255), rand(255), rand(255))) }
      @terrain  = Terrain.new(width, height, rand(10))
    end

    def render(win)
      win.clear(Ray::Color.white)

      terrain.draw(win)

      entities.each do |entity|
        entity.update
        entity.draw(win, terrain[entity.x])
      end
    end
  end
end

# require "pry"; binding.pry
