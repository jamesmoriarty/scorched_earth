require "scorched_earth/helpers"
require "scorched_earth/terrain"
require "scorched_earth/player"
require "scorched_earth/shot"
require "scorched_earth/explosion"
require "scorched_earth/mouse"
require "scorched_earth/color_palette"
require "scorched_earth/events/entity_created"
require "scorched_earth/events/game_ending"

include Java

import java.awt.Color

module ScorchedEarth
  class Game
    include Helpers

    attr_reader :width, :height,
      :color_palette, :entities, :mouse, :players, :terrain,
      :events, :event_listeners

    def initialize width, height
      @width, @height = width, height
    end

    def setup
      @color_palette   = ColorPalette.new Color::RED, Color::YELLOW, Color::WHITE
      @entities        = []
      @events          = Queue.new
      @event_listeners = []
      @players         = 2.times.map { |index| Player.new rand(width), color_palette.get("player_#{index}") }
      @terrain         = Terrain.new width, height, rand(10), color_palette.get("terrain")
      @mouse           = Mouse.new self

      on Events::EntityCreated do |event|
        entities << event.entity
      end

      on Events::GameEnding do |event|
        if event.time < Time.now
          setup
        else
          emit event
        end
      end
    end

    def update delta
      process_events!

      radius           = 50
      @entities.each { |entity| entity.update delta }
      @entities, @dead = *@entities.partition { |entity| terrain.fetch(entity.x, 0) < entity.y }
      @dead
        .select { |entity| entity.is_a? Shot }
        .select { |entity| entity.x < terrain.width && entity.x > 0 }
        .each   { |entity| terrain.bite entity.x, radius  }
        .each   { |entity| emit Events::EntityCreated.new(Explosion.new entity.x, entity.y) }
        .select { |entity| players.any? { |player| inside_radius? entity.x - player.x, 0, radius } }
        .each   { emit Events::GameEnding.new(Time.now + 1) }
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

      mouse.draw graphics

      terrain.draw graphics
    end

    def emit event
      events << event
    end

    def on klass, &block
      event_listeners << [klass, block]
    end

    private

    def process_events!
      until events.empty? do
        event = events.pop

        event_listeners.each do |klass, block|
          if event.is_a? klass
            block.call event
          end
        end
      end
    end
  end
end
