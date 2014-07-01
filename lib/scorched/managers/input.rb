require_relative "./manager"

module Scorched
  class Input < Manager
    include Ray::Helper

    attr_accessor :mouse_press_at

    def update
      if  holding?(key :right) || holding?(key :d)
        current_player.x = [current_player.x += 1, width - 1].min
      elsif holding?(key :left) || holding?(key :a)
        current_player.x = [current_player.x -= 1, 0].max
      end
    end

    def mouse_press
      @mouse_press_at = Time.now
    end

    def mouse_release(*args)
      Shot.create(
        x:          current_player.x,
        y:          current_player.y,
        velocity_x: velocity_x,
        velocity_y: velocity_y,
        angle:      angle,
        terrian:    terrian
      )

      next_player
    end

    def delta
      (Time.now - mouse_press_at) * 3 + 15
    end

    def x
      current_player.x - mouse_pos.x
    end

    def y
      current_player.y - (height - mouse_pos.y)
    end

    def angle
      Math.angle(x, y) + 270
    end

    def velocity_x
      Math.offsetX(angle, delta)
    end

    def velocity_y
      Math.offsetY(angle, delta)
    end
  end
end
