require "scorched_earth/helpers"

module ScorchedEarth
  class Mouse
    include Ray::Helper
    include Helpers

    attr_reader :mouse_press_at, :players, :terrain, :window

    def initialize(terrain, players)
      @terrain  = terrain
      @players  = players
    end

    def register(scene)
      self.event_runner = scene.event_runner
      @window           = scene.window

      add_hook :mouse_release, method(:mouse_release)
      add_hook :mouse_press,   method(:mouse_press)
    end

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

      raise_event :entity_created, Shot.new(current_player.x, terrain[current_player.x], velocity_x, velocity_y, Ray::Color.white)

      next_player
    end

    def mouse_press
      @mouse_press_at = Time.now
    end

    def draw(win)
      width, height = *window.size
      x1, y1        = *mouse_pos
      x2, y2        = current_player.x, height - terrain[current_player.x]

      win.draw Ray::Polygon.line([x1, y1], [x2, y2], 3, current_player.color)
    end
  end
end
