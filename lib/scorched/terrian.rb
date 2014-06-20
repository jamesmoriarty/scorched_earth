module Scorched
  class Terrian < Array
    def initialize(width, height, cycles)
      super(width) do |index|
        Math.sin(index.to_f / width.to_f * cycles.to_f) * height / 4 + (height / 4).to_i
      end
    end

    def deform(shot)
      x1 = shot.x - shot.radius
      x1 = [0, x1].max.to_i
      x2 = shot.x + shot.radius
      x2 = [size, x2].min.to_i

      Range.new(x1, x2).to_a.each do |x|
        cycle    = (x - shot.x).to_f / (shot.radius * 2).to_f + 0.5
        delta    = Math.sin(Math::PI * cycle) * shot.radius
        self[x] -= delta.to_i if x >= 0 && x < size
      end
    end
  end
end
