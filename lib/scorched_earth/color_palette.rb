include Java
import java.awt.Color

module ScorchedEarth
  class ColorPalette
    include Enumerable

    attr_reader :cache, :colors, :strategy

    def initialize(*colors)
      @cache    = {}
      @colors   = colors
      @strategy = Strategies::TriadMixing
    end

    def get(key)
      cache.fetch(key) do |key|
        cache[key] = first
      end
    end

    def each
      return enum_for(:each) unless block_given?

      loop do
        color = strategy.color(colors)
        yield color if not near_match?(color)
      end
    end

    def near_match?(color1, epsilon = 10)
      # cache.values.any? do |color2|
      #   a, b      = Color::RGB.new(*color1.to_a[0, 2]), Color::RGB.new(*color2.to_a[0, 2])
      #   delta_e94 = a.delta_e94(a.to_lab, b.to_lab)
      #
      #   delta_e94 < epsilon
      # end

      false
    end

    module Strategies
      module TriadMixing
        def self.color(colors)
          sum = 0.0

          colors.map do |color|
            sum += ratio = rand

            [color, ratio]
          end.inject(Color.new(0, 0, 0)) do |mix, (color, ratio)|
            scale = ratio / sum

            Color.new(
              (mix.red   + color.red   * scale).to_i,
              (mix.green + color.green * scale).to_i,
              (mix.blue  + color.blue  * scale).to_i,
            )
          end
        end
      end
    end
  end
end
