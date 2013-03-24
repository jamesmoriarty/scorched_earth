require "singleton"

class ColorBank
  include Singleton

  def initialize
    @colors = Queue.new
    @colors.push(::Gosu::Color.new(255,   80,   185,  255)) # light blue
    @colors.push(::Gosu::Color.new(255,   155,  155,  155)) # light brown
    @colors.push(::Gosu::Color.new(255,   178,  34,   34)) # red
    @colors.push(::Gosu::Color.new(255,   34,   139,  34)) # green
    @colors.push(::Gosu::Color.new(255,   148,  0,    211)) # purple
  end

  def checkout
    @colors.pop(true)
  end

  def deposit(color)
    @colors.push(color)
  end

end
