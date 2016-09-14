module Scorched
  class Player
    attr_reader :x, :color

    def initialize(x, color)
      @x, @color = x, color
    end

    def draw(win, y)
      width, height = *win.size

      win.draw Ray::Polygon.circle([x, height - y], 25, color)
    end
  end
end
