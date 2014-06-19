require_relative "./entity"

module Scorched
  class Shot < Entity
    def update
      move
      @velocity_y -= 0.5
      @angle       = Math.angle(velocity_y, velocity_x)
    end
  end
end
