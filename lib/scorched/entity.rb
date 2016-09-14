module Entity
  attr_reader :x, :y, :velocity_x, :velocity_y

  def intialize(x, y, velocity_x, velocity_y)
    @x, @y, @velocity_x, @velocity_y = x, y, velocity_x, velocity_y
  end

  def update(delta)
    raise NotImplementedError
  end

  def draw(win)
    raise NotImplementedError
  end
end
