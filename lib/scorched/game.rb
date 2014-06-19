require "ray"

require_relative "version"
require_relative "ext/array"
require_relative "ext/math"
require_relative "ext/ray/color"
require_relative "entities/player"
require_relative "entities/shot"
require_relative "entities/explosion"
require_relative "scenes/game_scene"

module Scorched
  class Game < Ray::Game
    def initialize
      super "Scorched #{VERSION}"

      GameScene.bind(self)

      scenes << :game
    end
  end
end
