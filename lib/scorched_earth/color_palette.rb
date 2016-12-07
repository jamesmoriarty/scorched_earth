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
        yield color
      end
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
