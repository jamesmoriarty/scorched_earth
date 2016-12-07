require "scorched_earth/helpers"
require "scorched_earth/events/mouse_pressed"
require "scorched_earth/events/mouse_released"
require "scorched_earth/events/mouse_moved"

module ScorchedEarth
  class Mouse
    include Helpers

    attr_reader :game, :mouse_pressed_at, :x, :y

    def initialize game
      @game = game

      game.on Events::MousePressed, &method(:mouse_pressed)
      game.on Events::MouseReleased, &method(:mouse_released)
      game.on Events::MouseMoved, &method(:mouse_moved)
    end

    def terrain
      game.terrain
    end

    def players
      game.players
    end

    def current_player
      players.first
    end

    def next_player
      players.rotate!
    end

    def mouse_released event
      return unless mouse_pressed_at

      delta         = (Time.now - mouse_pressed_at) * 1000 + 1000
      x1, y1        = event.x, event.y
      x2, y2        = current_player.x, height - terrain[current_player.x]
      degrees       = angle(y2 - y1, x2 - x1) + 180
      velocity_x    = offset_x(degrees, delta)
      velocity_y    = offset_y(degrees, delta)
      shot          = Shot.new current_player.x, terrain[current_player.x], velocity_x, velocity_y, Color.white

      game.emit Events::EntityCreated.new shot

      next_player
    end

    def mouse_pressed event
      @mouse_pressed_at = Time.now
    end

    def mouse_moved event
      @x, @y = event.x, event.y
    end

    def height
      game.height
    end

    def draw(graphics)
      return unless x && y

      height = graphics.destination.height
      x1, y1 = x, y
      x2, y2 = current_player.x, height - terrain[current_player.x]

      graphics.set_color player.color
      graphics.draw_line x1, y1, x2, y2
    end
  end
end
