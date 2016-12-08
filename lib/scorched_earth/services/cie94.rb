include Java

import java.awt.Color

module ScorchedEarth
  module Services
    # https://github.com/halostatue/color/blob/master/lib/color/rgb.rb
    class CIE94
      def call(color_1, color_2, weighting_type = :graphic_arts)
        color_1 = to_lab(color_1)
        color_2 = to_lab(color_2)

        case weighting_type
        when :graphic_arts
          k_1 = 0.045
          k_2 = 0.015
          k_L = 1
        when :textiles
          k_1 = 0.048
          k_2 = 0.014
          k_L = 2
        else
          raise ArgumentError, "Unsupported weighting type #{weighting_type}."
        end

        k_C = k_H = 1

        l_1, a_1, b_1 = color_1.values_at(:L, :a, :b)
        l_2, a_2, b_2 = color_2.values_at(:L, :a, :b)

        delta_a = a_1 - a_2
        delta_b = b_1 - b_2

        c_1 = Math.sqrt((a_1**2) + (b_1**2))
        c_2 = Math.sqrt((a_2**2) + (b_2**2))

        delta_L = color_1[:L] - color_2[:L]
        delta_C = c_1 - c_2

        delta_H2 = (delta_a**2) + (delta_b**2) - (delta_C**2)

        s_L = 1
        s_C = 1 + k_1 * c_1
        s_H = 1 + k_2 * c_1

        composite_L = (delta_L / (k_L * s_L))**2
        composite_C = (delta_C / (k_C * s_C))**2
        composite_H = delta_H2 / ((k_H * s_H)**2)

        Math.sqrt(composite_L + composite_C + composite_H)
      end

      private

      def to_xyz(color, _color_space = :sRGB)
        r, g, b = [color.red, color.green, color.blue].map do |v|
          if v > 0.04045
            (((v + 0.055) / 1.055)**2.4) * 100
          else
            (v / 12.92) * 100
          end
        end

        # Convert using the RGB/XYZ matrix at:
        # http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html#WSMatrices
        {
          x: (r * 0.4124564 + g * 0.3575761 + b * 0.1804375),
          y: (r * 0.2126729 + g * 0.7151522 + b * 0.0721750),
          z: (r * 0.0193339 + g * 0.1191920 + b * 0.9503041)
        }
      end

      def to_lab(color, _color_space = :sRGB, reference_white = [95.047, 100.00, 108.883])
        xyz = to_xyz color

        xr = xyz[:x] / reference_white[0]
        yr = xyz[:y] / reference_white[1]
        zr = xyz[:z] / reference_white[2]

        epsilon = (216 / 24_389.0)
        kappa   = (24_389 / 27.0)

        fx, fy, fz = [xr, yr, zr].map do |t|
          if t > epsilon
            t**(1.0 / 3)
          else # t <= epsilon
            ((kappa * t) + 16) / 116.0
          end
        end

        {
          L: ((116 * fy) - 16),
          a: (500 * (fx - fy)),
          b: (200 * (fy - fz))
        }
      end
    end
  end
end
