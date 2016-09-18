module ScorchedEarth
  class Player
    attr_reader :x, :color

    CIRCLE_RADIUS = 15

    def initialize(x, color)
      @x, @color = x, color
    end

    def draw(win, y)
      width, height = *win.size

      win.draw Ray::Polygon.circle([x, height - y], CIRCLE_RADIUS, color)
    end
  end
end
