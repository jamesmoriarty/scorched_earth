module ScorchedEarth
  module Services
    class Wave
      attr_reader :width, :height, :phases

      def initialize(width, height, phases)
        @width  = width
        @height = height
        @phases = phases
      end

      def each
        return enum_for(:each) unless block_given?

        width.times do |index|
          yield Math.sin(index.to_f / width * phases) * height / 4 + (height / 4)
        end
      end
    end
  end
end
