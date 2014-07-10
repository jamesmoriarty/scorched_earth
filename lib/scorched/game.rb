require "ray"

require_relative "ext/math"
require_relative "version"
require_relative "terrain"
require_relative "game_object"
require_relative "entities/player"
require_relative "entities/shot"
require_relative "entities/explosion"
require_relative "managers/input"
require_relative "managers/ui"
require_relative "managers/collision"
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
