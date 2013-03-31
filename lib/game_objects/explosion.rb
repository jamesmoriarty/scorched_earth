class Explosion < Chingu::Particle

  def setup
    super
    self.scale      = 0.5
    self.scale_rate = 0.1
    self.fade_rate  = -10
    self.mode       = :additive
    self.image      = Gosu::Image["particle.png"]
    self.color      = Gosu::Color.new(255,255,0)
    Gosu::Sound["explosion.wav"].play(0.5)
  end

  def update
    super

    destroy if alpha <= 0
  end

end
