module Entity
  attr_reader :x, :y

  def intialize(x, y)
    @x, @y = x, y
  end

  def update
    raise NotImplementedError
  end

  def draw(win, y)
    raise NotImplementedError
  end
end
