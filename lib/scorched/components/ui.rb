require "components/component"

module Scorched
  class UI < Component
    def render(win, height)
      return unless current_player

      win.draw Ray::Polygon.line([current_player.x, height - current_player.y], mouse_pos, 2, current_player.color)
    end
  end
end
