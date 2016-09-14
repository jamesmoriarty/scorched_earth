require "scorched/helpers"
require "scorched/terrain"
require "scorched/player"
require "scorched/shot"

module Scorched
  class GameScene < Ray::Scene
    include Helpers

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
      @players      = 2.times.map { Player.new rand(width), random_color }
      @terrain      = Terrain.new width, height, rand(10), random_color
    end

    def render(win)
      win.clear Ray::Color.white

      players.each do |player|
        player.draw win, terrain[player.x]
      end

      terrain.draw(win)

      entities.each do |entity|
        entity.update 1.0 / frames_per_second
        entity.draw win
      end
    end

    attr_reader :mouse_press_at

    def current_player
      players.first
    end

    def next_player
      players.rotate!
    end

    def mouse_release
      delta         = (Time.now - mouse_press_at) * 1000 + 1000
      width, height = *window.size
      x1, y1        = *mouse_pos
      x2, y2        = current_player.x, height - terrain[current_player.x]
      degrees       = angle(y2 - y1, x2 - x1) + 180
      velocity_x    = offset_x(degrees, delta)
      velocity_y    = offset_y(degrees, delta)

      @entities << Shot.new(current_player.x, terrain[current_player.x], velocity_x, velocity_y)

      next_player
    end

    def mouse_press
      @mouse_press_at = Time.now
    end
  end
end

# require "pry"; binding.pry

# puts "delta    = #{delta}"
# puts "(x1, y1) = #{x1}, #{y1}"
# puts "(x2, y2) = #{x2}, #{y2}"
# puts "degrees  = #{degrees}"
# puts "(velocity_x, velocity_y) = #{velocity_x}, #{velocity_y}"
