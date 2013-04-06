class Timer
  attr_accessor :started_at

  def start
    self.started_at = Time.now
  end

  def started_at_seconds_ago
    started_at.nil?? 0 : Time.now - self.started_at
  end

  def to_s
    "%02d" % started_at_seconds_ago
  end
end
