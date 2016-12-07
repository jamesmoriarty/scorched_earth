module ScorchedEarth
  class Player
    attr_reader :x, :color

    def initialize(x, color)
      @x     = x
      @color = color
    end

    def draw(graphics, y)
      height = graphics.destination.height
      radius = 20

      graphics.set_color color
      graphics.fill_oval x - radius / 2, height - y - radius / 2, radius, radius
    end
  end
end
