module Scorched
  class Terrain < Array
    attr_reader :color

    def initialize(width, height, cycles)
      @color = Ray::Color.new(rand(255), rand(255), rand(255))

      super(width) do |index|
        Math.sin(index.to_f / width.to_f * cycles.to_f) * height / 4 + (height / 4).to_i
      end
    end

    def width
      size
    end

    def draw(win)
      width, height = *win.size

      win.draw image(height)
    end

    def image(height)
      @cache ||= begin
       image = Ray::Image.new [width, height]

       Ray::ImageTarget.new(image) do |target|
         each_with_index do |y, x|
           target.draw Ray::Polygon.line([x, height], [x, height - y], 1, color)
         end

         target.update
       end

       Ray::Sprite.new image, at: [0, 0]
     end
   end
  end
end
