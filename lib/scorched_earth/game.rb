require "scorched_earth/helpers"
require "scorched_earth/terrain"
require "scorched_earth/player"
require "scorched_earth/shot"
require "scorched_earth/explosion"
# require "scorched_earth/mouse"
require "scorched_earth/color_palette"

include Java

import java.awt.Color

module ScorchedEarth
  class Game
    include Helpers

    attr_reader :width, :height,
      :color_palette, :entities, :mouse, :players, :terrain

    def initialize width, height
      @width, @height = width, height
    end

    def setup
      @color_palette = ColorPalette.new Color::RED, Color::YELLOW, Color::WHITE
      @entities      = []
      @players       = 2.times.map { |index| Player.new rand(width), color_palette.get("player_#{index}") }
      @terrain       = Terrain.new width, height, rand(10), color_palette.get("terrain")
      # @mouse         = Mouse.new terrain, players
    end

    def update delta
      radius           = 50
      @entities.each { |entity| entity.update delta }
      @entities, @dead = *@entities.partition { |entity| terrain.fetch(entity.x, 0) < entity.y }
      @dead
        .select { |entity| entity.is_a? Shot }
        .select { |entity| entity.x < terrain.width && entity.x > 0 }
        .each   { |entity| terrain.bite entity.x, radius  }
        .each   { |entity| raise_event :entity_created, Explosion.new(entity.x, entity.y) }
        .select { |entity| players.any? { |player| inside_radius? entity.x - player.x, 0, radius } }
        .each   { raise_event :game_ending, Time.now + 0.25 }
    end

    def render graphics
      graphics.set_color color_palette.get("sky")
      graphics.fill_rect 0, 0, width, height

      entities.each do |entity|
        entity.draw graphics
      end

      players.each do |player|
        player.draw graphics, terrain[player.x]
      end

      # mouse.draw win

      terrain.draw graphics
    end
  end
end
