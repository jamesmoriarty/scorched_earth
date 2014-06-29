module Math
  def self.angle(x, y)
    normalize radian_to_deg atan2(y, x)
  end

  def self.radian_to_deg(radian)
    radian * (180 / PI)
  end

  def self.offsetX(angle, radius)
    sin(angle / 180 * PI) * radius
  end

  def self.offsetY(angle, radius)
    - cos(angle / 180 * PI) * radius
  end

  def self.normalize(angle)
    result = angle % 360
    loop do
      break if result > 0
      result = result + 360
    end
    result
  end

  # http://en.wikipedia.org/wiki/Midpoint_circle_algorithm
  def self.circle(radius)
    x = -radius

    loop do
      break unless x <= radius
      y = Math.sqrt(radius**2 - x**2)
      yield(x, y)
      x += 1
    end
  end

  def self.inside_radius?(x, y, radius)
    x ** 2 + y ** 2 < radius ** 2
  end
end
