module ScorchedEarth
  class Explosion
    attr_reader :x, :y, :radius

    def initialize(x, y, radius = 25)
      @x      = x
      @y      = y
      @radius = radius

      freeze
    end

    def update(_delta)
      self.class.new(x, y, radius + 25) if radius < 125
    end
  end
end
