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

    def circle(radius)
      x = -radius

      loop do
        break unless x <= radius
        y = Math.sqrt(radius**2 - x**2)
        yield(x, y)
        x += 1
      end
    end

    def inside_radius?(x, y, radius)
      x ** 2 + y ** 2 < radius ** 2
    end

    module_function :angle, :circle, :inside_radius?, :radians_to_degrees, :degrees_to_radians, :normalize_degrees, :offset_x, :offset_y
  end
end
