module ScorchedEarth
  class Player
    attr_reader :x, :y, :color

    def initialize(x, y, color)
      @x     = x
      @y     = y
      @color = color

      freeze
    end
  end
end
