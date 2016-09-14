module Scorched
  module Helpers
    def normalize_degrees(degrees)
      (degrees + 360 * 2e10) % 360
    end

    def angle(x, y)
      normalize_degrees radians_to_degrees Math.atan2(y, x)
    end

    def radians_to_degrees(radians)
      radians * (180 / Math::PI)
    end

    def degrees_to_radians(degrees)
      degrees / 180 * Math::PI
    end

    def offset_x(degrees, radius)
      Math.sin(degrees_to_radians(degrees)) * radius
    end

    def offset_y(degrees, radius)
      - Math.cos(degrees_to_radians(degrees)) * radius
    end

    def random_color
      Ray::Color.new(rand(255), rand(255), rand(255))
    end

    module_function :angle, :radians_to_degrees, :degrees_to_radians, :normalize_degrees, :offset_x, :offset_y
  end
end
