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
        color = Strategies::TriadMixing.call(colors)
        return color if not near_match?(color)
      end
    end

    def near_match?(color1)
      cache.values.any? do |color2|
        a, b      = Color::RGB.new(*color1.to_a[0, 2]), Color::RGB.new(*color2.to_a[0, 2])
        delta_e94 = a.delta_e94(a.to_lab, b.to_lab)

        delta_e94 < 10
      end
    end

    module Strategies
      module TriadMixing
        def self.call(colors, scale = 0.5, sum = 0.0, random_index = rand(colors.size - 1))
          colors.each_with_index.map do |color, index|
            ratio = random_index == index ? rand * scale : rand
            sum  += ratio
            [color, ratio]
          end.inject(Ray::Color.new(0, 0, 0)) do |mix, (color, ratio)|
            Ray::Color.new(
              mix.red   + color.red   * (ratio / sum),
              mix.green + color.green * (ratio / sum),
              mix.blue  + color.blue  * (ratio / sum),
            )
          end
        end
      end
    end
  end
end
