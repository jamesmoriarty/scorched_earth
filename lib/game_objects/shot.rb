class Shot < Chingu::GameObject
  has_traits :effect, :velocity, :collision_detection, :timer

  def setup
    super

    @image = Gosu::Image["particle.png"]
  end

  def update
    super
    Smoke.create(:x => x, :y => y)
  end

end
