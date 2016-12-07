require 'scorched_earth/helpers'
require 'scorched_earth/events/mouse_pressed'
require 'scorched_earth/events/mouse_released'
require 'scorched_earth/events/mouse_moved'

module ScorchedEarth
  class Mouse
    include Helpers

    attr_reader :event_runner, :players, :terrain, :mouse_pressed_at, :x, :y

    def initialize(event_runner, players, terrain)
      @event_runner = event_runner
      @players      = players
      @terrain      = terrain
    end

    def current_player
      players.first
    end

    def next_player
      players.rotate!
    end

    def mouse_released(event)
      return unless mouse_pressed_at

      delta      = (Time.now - mouse_pressed_at) * 1000 + 1000
      x1         = event.x
      y1         = event.y
      x2         = current_player.x
      y2         = height - terrain[current_player.x]
      degrees    = angle(y2 - y1, x2 - x1) + 180
      velocity_x = offset_x(degrees, delta)
      velocity_y = offset_y(degrees, delta)
      shot       = Shot.new current_player.x, terrain[current_player.x], velocity_x, velocity_y, Color.white

      event_runner.publish Events::EntityCreated.new shot

      next_player
    end

    def mouse_pressed(_event)
      @mouse_pressed_at = Time.now
    end

    def mouse_moved(event)
      @x = event.x
      @y = event.y
    end

    def height
      terrain.height
    end

    def draw(graphics)
      return unless x && y

      height = graphics.destination.height
      x1     = x
      y1     = y
      x2     = current_player.x
      y2     = height - terrain[current_player.x]

      graphics.set_color player.color
      graphics.draw_line x1, y1, x2, y2
    end
  end
end
