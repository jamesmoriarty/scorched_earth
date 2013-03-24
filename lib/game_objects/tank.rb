class Tank < Chingu::GameObject
  has_traits :effect, :velocity, :collision_detection, :timer
  # trait :bounding_box, :scale => 0.7, :debug => $DEBUG
  attr_accessor :firing

  def setup
    self.rotation_center  = :bottom_center
    self.image = Gosu::Image["tank.png"]
    self.color = ColorBank.instance.checkout # Gosu::Color.new(255,rand(255), rand(255), rand(255))
  end

  def self.destroy_all
    Tank.all.each do |tank|
      ColorBank.instance.deposit(tank.color)
    end
    super
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

  def right
    during(1000){ self.velocity_x = 1 }.then{ self.velocity_x = 0 } if stopped?
  end

  def left
    during(1000){ self.velocity_x = -1 }.then{ self.velocity_x = 0 } if stopped?
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



