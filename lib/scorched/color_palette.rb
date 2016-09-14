module Scorched
  class ColorPalette
    attr_reader :colors, :cache

    def initialize(*colors)
      @colors = colors
      @cache  = {}
    end

    def get(key)
      cache.fetch(key) do |key|
        cache[key] = random
      end
    end

    def random
      scale, sum   = 2.0, 0.0
      random_index = rand(colors.size)

      mix_ratios = colors.each_with_index.map do |color, index|
        ratio = random_index == index ? rand * scale : rand
        sum  += ratio

        [color, ratio]
      end.map do |color, ratio|
        [color, ratio / sum]
      end

      mix_ratios.inject(Ray::Color.new(0, 0, 0)) do |mix, (color, ratio)|
        Ray::Color.new(
          mix.red   + color.red   * ratio,
          mix.green + color.green * ratio,
          mix.blue  + color.blue  * ratio,
        )
      end
    end
  end
end
