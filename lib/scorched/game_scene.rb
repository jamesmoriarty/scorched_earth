require "scorched/terrain"
require "scorched/player"

module Scorched
  class GameScene < Ray::Scene
    attr_reader :entities, :players, :terrain

    def register
      add_hook :quit,                    method(:exit!)
      add_hook :key_press, key(:escape), method(:exit!)
      add_hook :mouse_release,           method(:mouse_release)
      add_hook :mouse_press,             method(:mouse_press)
    end

    def setup
      width, height = *window.size
      @entities     = []
      @players      = 2.times.map { Player.new rand(width), Ray::Color.new(rand(255), rand(255), rand(255)) }
      @terrain      = Terrain.new width, height, rand(10)
    end

    def render(win)
      win.clear Ray::Color.white

      terrain.draw(win)

      players.each do |player|
        player.draw win, terrain[player.x]
      end

      entities.each do |entity|
        entity.update
        entity.draw win
      end
    end

    attr_reader :mouse_press_at

    def current_player
      players.first
    end

    def next_player
      players.rotate!

      current_player
    end

    def mouse_release
      width, height = *window.size
      x1, y1        = *mouse_pos
      x2, y2        = current_player.x, height - terrain[current_player.x]
      radians       = Math.atan2(y2 - y1, x2 - x1)
      degrees       = radians * (180 / Math::PI)

      puts "(x1, y1) = #{x1}, #{y1}"
      puts "(x2, y2) = #{x2}, #{y2}"
    end

    def mouse_press
      @mouse_press_at = Time.now
    end
  end
end

# require "pry"; binding.pry
