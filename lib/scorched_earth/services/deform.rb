require 'scorched_earth/helpers'

module ScorchedEarth
  module Services
    class Deform
      include Helpers
      attr_reader :array

      def initialize(array)
        @array = array
      end

      def call(center_x, radius, center_y = array[center_x])
        new_array = array.dup
        circle(radius) do |offset_x, offset_y|
          x = center_x + offset_x
          y = array[x]
          next unless y
          z = offset_y * 2
          q = center_y - offset_y
          q = y if q > y

          new_array[x] = [y - z, q, 0].max
        end

        new_array
      end
    end
  end
end
