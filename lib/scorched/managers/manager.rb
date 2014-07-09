require "forwardable"
require_relative "../game_object"

module Scorched
  class Manager < GameObject
    extend Forwardable
    def_delegators :@game, :window, :width, :height, :mouse_pos, :terrian, :current_player, :next_player

    def initialize(game)
      @game = game
    end
  end
end
