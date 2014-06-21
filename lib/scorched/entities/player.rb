require_relative "./entity"

module Scorched
  class Player < Entity
    class << self
      def random_color
        colors.rotate![0]
      end

      def colors
        @colors ||= [Ray::Color.new(9, 112, 84), Ray::Color.new(255, 153, 0)].shuffle
      end
    end

    attr_accessor :color, :terrian

    def initialize(terrian)
      super(Hash.new)
      @terrian = terrian
      @x       = rand(terrian.size)
      @color   = self.class.random_color
    end

    def render(win, height)
      win.draw Ray::Polygon.circle([x, height - y], 10, color)
    end

    def y
      terrian[x]
    end
  end
end
