module ScorchedEarth
  class Player
    attr_reader :x, :y

    def initialize(x, y)
      @x     = x
      @y     = y

      freeze
    end
  end
end
