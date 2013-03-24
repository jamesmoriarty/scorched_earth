class Smoke < Chingu::Particle
  traits :timer

  def setup
    super
    self.scale      = 0.1
    self.scale_rate = 0.01
    self.fade_rate  = -0.5
    self.mode = :default
    self.image = Gosu::Image["particle.png"]
    self.color = Gosu::Color.new(0xFFFFFFFF)
  end

  def update
    super
    destroy if alpha <= 0
  end
end
