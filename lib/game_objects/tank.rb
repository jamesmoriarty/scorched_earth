class Tank < Chingu::GameObject
  has_traits :effect, :velocity, :collision_detection, :timer
  # trait :bounding_box, :scale => 0.7, :debug => $DEBUG
  attr_accessor :firing

  def setup
    self.rotation_center  = :bottom_center
    self.image = Gosu::Image["tank.png"]
    self.color = ColorBank.instance.next # Gosu::Color.new(255,rand(255), rand(255), rand(255))
  end

  def move(x, y)
    self.x += x
    self.y += y

    # test pixels to climb or drop.
    (-5..5).to_a.each do |y_offset|
      has_free  = !$window.current_game_state.terrain.collide_point?(self.x, self.y + y_offset)
      has_solid = $window.current_game_state.terrain.collide_point?(self.x, self.y + y_offset + 1)
      if has_free and has_solid
        self.y = self.y + y_offset
        return
      end
    end

    self.x = previous_x
    self.y = previous_y
  end

  def update
    super

    if moved?
      angles = []
      # TODO - refactor window out and optimize - this is slow.
      [4, 10, 15, 25].each do |offset|
        x1 = x - offset
        next if x1 < 0
        y1 = $window.current_game_state.terrain.highest_collide_point(x1)

        x2 = x + offset
        next if x2 >= $window.current_game_state.terrain.width
        y2 = $window.current_game_state.terrain.highest_collide_point(x2)

        angles << Gosu.angle(x1, y1, x2, y2)
      end

      self.angle = 270 + (angles.inject(:+) / angles.size) unless angles.size == 0
    end

  end

  def right
    during(3000){ self.velocity_x = 1 }.then{ self.velocity_x = 0 } if stopped?
  end

  def left
    during(3000){ self.velocity_x = -1 }.then{ self.velocity_x = 0 } if stopped?
  end

  def try_fire(angle)
    unless firing
      puts "#try_fire(#{angle})" if $DEBUG
      Shot.create(
        :x              => x,
        :y              => y + fire_y_offset,
        :velocity_x     => Gosu.offset_x(angle, 13),
        :velocity_y     => Gosu.offset_y(angle, 13),
        :acceleration_y => 0.3,
        :angle          => angle
      )
      self.firing = true
      after(1000){ self.firing = false }

      return true
    end

    return false
  end

  def fire_y_offset; -30; end

end



