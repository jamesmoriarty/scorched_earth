module ScorchedEarth
  class Shot
    class Trajectory < Array
      def initialize(*args)
        super

        freeze
      end

      def update(*args)
        self
      end
     end

    attr_reader :x, :y, :velocity_x, :velocity_y, :trajectory

    def initialize(x, y, velocity_x, velocity_y, trajectory = Trajectory.new)
      @x          = x
      @y          = y
      @velocity_x = velocity_x
      @velocity_y = velocity_y
      @trajectory = Trajectory.new trajectory + [[x, y]]

      freeze
    end

    def update(delta)
      self.class.new(
        x + velocity_x * delta,
        y + velocity_y * delta,
        velocity_x,
        velocity_y - gravity * delta,
        trajectory
      )
    end

    def gravity
      2000
    end
  end
end
