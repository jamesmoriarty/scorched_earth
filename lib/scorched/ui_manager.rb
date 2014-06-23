require "delegate"

module Scorched
  class UIManager < SimpleDelegator
    def render(win, height)
      if current_player
        win.draw Ray::Polygon.line([current_player.x, height - current_player.y], mouse_pos, 2, current_player.color)
      end
    end
  end
end
