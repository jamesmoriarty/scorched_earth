module ScorchedEarth
  class Explosion
    attr_reader :x, :y, :color, :radius

    def initialize(x, y)
      @x, @y, @radius = x, y, 10
    end

    def update(delta)
      @radius += 10
      @x      -= 1_000_000 if radius > 50
    end

    def draw(win)
      width, height = *win.size

      win.draw Ray::Polygon.circle([x, height - y], radius, Ray::Color.white)
    end
  end
end
