module Scorched
  module Helpers
    def angle(x, y)
      radians_to_degrees Math.atan2(y, x)
    end

    def radians_to_degrees(radians)
      radians * (180 / Math::PI)
    end

     module_function :angle, :radians_to_degrees
  end
end
