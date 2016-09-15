module Ray
  class Color
    def hue
      h,s     = 0
      r_scale = r / 255.0
      g_scale = g / 255.0
      b_scale = b / 255.0
      max     = [r_scale, g_scale, b_scale].max
      min     = [r_scale, g_scale, b_scale].min
      delta   = max - min
      v       = max * 100

      if (max != 0.0)
        s = delta / max *100
      else
        s = 0.0
      end

      if (s == 0.0)
         h = 0.0
      else
        if (r_scale == max)
          h = (g_scale - b_scale) / delta
        elsif (g_scale == max)
          h = 2 + (b_scale - r_scale) / delta
        elsif (b_scale == max)
          h = 4 + (r_scale - g_scale) / delta
        end

        h *= 60.0

        if (h < 0)
          h += 360.0
        end
      end

      return h
    end
  end
end
