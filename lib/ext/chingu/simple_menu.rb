module Chingu
  class SimpleMenu < BasicGameObject
    def on_select(object)
      object.color = ::Gosu::Color::YELLOW
    end

    def on_deselect(object)
      object.color = ::Gosu::Color::WHITE
    end
  end
end
