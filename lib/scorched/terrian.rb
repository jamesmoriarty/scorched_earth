module Scorched
  class Terrian < Array
    def initialize(width, height, cycles)
      super(width) do |index|
        Math.sin(index.to_f / width.to_f * cycles.to_f) * height / 4 + (height / 4).to_i
      end
    end

    def render(win, height)
      each_with_index do |y, x|
        win.draw Ray::Polygon.line([x, height], [x, height - y], 1, Ray::Color.brown)
      end
    end

    def deform(x, radius)
      x1 = x - radius
      x2 = x + radius

      Range.new(x1.to_i, x2.to_i).to_a.each do |x_offset|
        cycle = (x_offset - x).to_f / (radius * 2).to_f + 0.5
        delta = Math.sin(Math::PI * cycle) * radius
        self[x_offset] -= delta.to_i if x_offset >= 0 && x_offset < size
      end
    end
  end
end
