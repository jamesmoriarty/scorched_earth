require "singleton"

class Terrain < Delegator
  include Singleton

  attr_accessor :image

  def initialize
    generate
  end

  def generate
    # http://banisterfiend.wordpress.com/2008/08/23/texplay-an-image-manipulation-tool-for-ruby-and-gosu/
    self.image ||= ::TexPlay.create_image($window, $window.width, $window.height)

    # bounds
    x1, y1  = 0, $window.height/1.5
    x2, y2  = $window.width, $window.height

    # paint terrain
    image.paint do
      rect 0, 0, x2, y2, :fill => true, :color => Gosu::Color.new(0, 0, 0, 0)
      cycles = rand(10)
      x1 = 0.0
      while(x1 < $window.width) do
        y1 = ( Math.sin(x1/$window.width*cycles) * 100 ) + $window.height/1.5
        line(x1, y1, x1, y2, :fill => true, :texture => Gosu::Image["terrain.png"])
        line(x1, y1, x1, y1, :fill => true, :color => Gosu::Color.new(255, 75, 75, 75))
        x1 += 1.0
      end
    end

    # set delegate object
    @delegate_sd_obj = image
  end

  def __getobj__
    @delegate_sd_obj # return object we are delegating to, required
  end

  def draw
    image.draw(0, 0, 0)
  end

  def collide_point?(x, y)
    return false if x < 0 || y < 0 || x > image.width || y > image.height
    image.get_pixel(x, y)[3] != 0 rescue false
  end

  def highest_collide_point(x)
    (0..height).to_a.each do |y|
      return y if collide_point?(x, y)
    end
  end

  def remove_circle(center_x, center_y, radius=1)
    image.paint do
      circle(center_x, center_y, radius, :color => [0, 0, 0, 0], :fill => true)
    end
  end

end
