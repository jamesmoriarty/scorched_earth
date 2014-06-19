require_relative "./entity"

module Scorched
  class Player < Entity
    attr_accessor :x, :y, :color, :terrian

    def initialize(terrian)
      super({})
      @terrian = terrian
      @x       = rand(terrian.size)
      @color   = self.class.random_color
    end

    def y
      terrian[x]
    end

    def self.random_color
      Ray::Color.send(colors.rotate![0])
    end

    def self.colors
      @colors ||= [:red, :green, :blue, :cyan, :yellow, :fuschia].shuffle
    end
  end
end
