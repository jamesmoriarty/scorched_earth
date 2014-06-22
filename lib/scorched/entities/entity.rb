module Scorched
  class Entity
    class << self
      attr_accessor :all

      def all
        @all ||= []
      end

      def create(*args)
        all << new(*args)
        all.last
      end

      def descendants
        @cache ||= begin
          ObjectSpace.each_object(Class).select do |klass|
            klass < self
          end
        end
      end
    end

    attr_accessor :x, :y, :velocity_x, :velocity_y, :angle, :terrian

    def initialize(x: 0, y: 0, velocity_x: 0, velocity_y: 0, angle: 0, terrian: nil)
      @x, @y, @velocity_x, @velocity_y, @angle, @terrian = x, y, velocity_x, velocity_y, angle, terrian
    end

    def destroy
      self.class.all.delete(self)
    end

    def update
      move
    end

    def render(win, height)
    end

    def move
      @x += velocity_x
      @y += velocity_y
    end
  end
end
