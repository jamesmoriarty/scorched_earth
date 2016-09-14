module Scorched
  module Helpers
    def angle(x, y)
      radians_to_degrees Math.atan2(y, x)
    end

    def radians_to_degrees(radians)
      radians * (180 / Math::PI)
    end

    def degrees_to_radians(degrees)
      degrees / 180 * Math::PI
    end

    def offset_x(degrees, radius)
      Math.sin(degrees_to_radians(degrees) * radius)
    end

    def offset_y(degrees, radius)
      - Math.cos(degrees_to_radians(degrees) * radius)
    end

    module_function :angle, :radians_to_degrees, :degrees_to_radians, :offset_x, :offset_y
  end
end
