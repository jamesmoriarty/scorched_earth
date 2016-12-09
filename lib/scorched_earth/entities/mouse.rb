module ScorchedEarth
  class Mouse
    attr_reader :x, :y, :pressed_at

    def initialize(x = nil, y = nil, pressed_at = nil)
      @x          = x
      @y          = y
      @pressed_at = pressed_at

      freeze
    end
  end
end
