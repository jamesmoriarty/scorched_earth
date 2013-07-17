require "singleton"

class ColorIterator
  include Singleton

  def initialize
    @index  = 0
    @colors = []
    @colors << ::Gosu::Color.new(255,   100,  200,  100) # light brown
    @colors << ::Gosu::Color.new(255,   80,   185,  255) # light blue
    @colors << ::Gosu::Color.new(255,   255,  255,  255) # bright orange
  end

  def next
    @colors[@index + 1] ? @index += 1 : @index = 0
    @colors[@index]
  end

end
