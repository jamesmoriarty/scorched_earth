module Scorched
  class ColorPalette
    attr_reader :colors, :cache

    def initialize(*colors)
      @colors = colors
      @cache  = {}
    end

    def get(key)
      cache.fetch(key) do |key|
        cache[key] = next_color
      end
    end

    def next_color
      loop do
        color = random
        return color if not close?(color)
        puts "#{color}"
      end
    end

    def close?(color1)
      cache.values.any? do |color2|
        a, b      = Color::RGB.new(*color1.to_a[0, 2]), Color::RGB.new(*color2.to_a[0, 2])
        delta_e94 = a.delta_e94(a.to_lab, b.to_lab)

        puts "delta_e94 = #{delta_e94}"

        delta_e94 < 10
      end
    end

    def random
      scale, sum   = 0.5, 0.0
      random_index = rand colors.size

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
