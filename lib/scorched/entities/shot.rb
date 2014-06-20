require_relative "./entity"

module Scorched
  class Shot < Entity
    def radius
      30
    end

    def update
      move
      @velocity_y -= 0.5
      @angle       = Math.angle(velocity_y, velocity_x)
    end

    def destroy
      super
      
      Explosion.create(x: x, y: y)
    end
  end
end
