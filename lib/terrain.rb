class Terrain
  attr_accessor :image

  def initialize(window)
    # http://banisterfiend.wordpress.com/2008/08/23/texplay-an-image-manipulation-tool-for-ruby-and-gosu/
    self.image = ::TexPlay.create_image(window, window.width, window.height)

    x1, y1  = 0, window.height/1.5
    x2, y2  = window.width, window.height

    image.paint do
      # solid rect
      # rect(x1, y1, x2, y2, :color => :green, :fill => true, :texture => Gosu::Image["terrain.png"])

      cycles = rand(10)
      x1 = 0.0
      while(x1 < window.width) do
        y1 = ( Math.sin(x1/window.width*cycles) * 100 ) + window.height/1.5
        line(x1, y1, x1, y2, :color => :green, :fill => true, :texture => Gosu::Image["terrain.png"])
        x1 += 1.0
      end
    end
  end

  def draw
    image.draw(0, 0, 0)
  end

  def collide_point?(x, y)
    return false if x < 0 || y < 0 || x > image.width || y > image.height
    image.get_pixel(x, y)[3] != 0 rescue false
  end

  def remove_circle(center_x, center_y, radius=1)
    image.paint do
      circle(center_x, center_y, radius, :color => [0, 0, 0, 0], :fill => true)
    end
  end

end
