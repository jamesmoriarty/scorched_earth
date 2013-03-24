class Shot < Chingu::GameObject
  has_traits :effect, :velocity, :collision_detection, :timer

  def setup
    super

    @image = Gosu::Image["shot.png"]
  end

  def update
    super
    self.angle = Gosu.angle(x, y, x + velocity_x, y + velocity_y)
    Smoke.create(:x => x, :y => y)
  end

end
