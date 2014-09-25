require "ray"

$:.unshift File.dirname(__FILE__)

require "ext/math"
require "version"
require "scenes/game_scene"

module Scorched
  class Game < Ray::Game
    def initialize
      super "Scorched #{VERSION}"

      GameScene.bind(self)

      scenes << :game
    end
  end
end
