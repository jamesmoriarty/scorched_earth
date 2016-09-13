require "ray"
require "scorched/entity"

module Scorched
  class Player
    include Entity

    attr_reader :color

    def initialize(x, color)
      @x, @color = x, color
    end

    def update; end

    def draw(win, y)
      width, height = *win.size

      win.draw Ray::Polygon.circle([x, height - y], 10, color)
    end
  end
end
