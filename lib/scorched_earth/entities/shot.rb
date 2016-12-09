module ScorchedEarth
  class Shot
    attr_reader :x, :y, :velocity_x, :velocity_y

    def initialize(x, y, velocity_x, velocity_y)
      @x          = x
      @y          = y
      @velocity_x = velocity_x
      @velocity_y = velocity_y

      freeze
    end

    def update(delta)
      self.class.new(
        x + velocity_x * delta,
        y + velocity_y * delta,
        velocity_x,
        velocity_y - gravity * delta
      )
    end

    def gravity
      2000
    end
  end
end
