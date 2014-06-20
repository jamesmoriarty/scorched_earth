require "delegate"

module Scorched
  class InputManager < SimpleDelegator
    attr_accessor :mouse_press_at

    def mouse_press
      @mouse_press_at = Time.now
    end

    def mouse_release(x, y)
      delta      = (Time.now - mouse_press_at) * 3 + 10
      x          = current_player.x - mouse_pos.x
      y          = current_player.y - (height - mouse_pos.y)
      angle      = Math.angle(x, y) + 270
      velocity_x = Math.offsetX(angle, delta)
      velocity_y = Math.offsetY(angle, delta)

      Shot.create(
        x:          current_player.x,
        y:          current_player.y,
        velocity_x: velocity_x,
        velocity_y: velocity_y,
        angle:      angle
      )

      next_player
    end
  end
end
