module ScorchedEarth
  class Explosion
    attr_reader :x, :y, :color, :radius

    def initialize(x, y)
      @x, @y, @radius = x, y, 25
    end

    def update(delta)
      @radius += 25
      @x      -= 1_000_000 if radius > 100
    end

    def draw(graphics)
      height = graphics.destination.height

      graphics.set_color Color.white
      graphics.fill_oval x - radius / 2, height - y - radius / 2, radius, radius
    end
  end
end
