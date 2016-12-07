require 'scorched_earth/helpers'
require 'scorched_earth/terrain'
require 'scorched_earth/player'
require 'scorched_earth/shot'
require 'scorched_earth/explosion'
require 'scorched_earth/mouse'
require 'scorched_earth/color_palette'
require 'scorched_earth/event_runner'
require 'scorched_earth/events/entity_created'
require 'scorched_earth/events/game_ending'

include Java

import java.awt.Color

module ScorchedEarth
  class Game
    include Helpers

    attr_reader :width, :height,
                :color_palette, :entities, :mouse, :players, :terrain,
                :event_runner

    def initialize(width, height)
      @width  = width
      @height = height
    end

    def setup
      @color_palette = ColorPalette.new Color::RED, Color::YELLOW, Color::WHITE
      @entities      = []
      @event_runner  = EventRunner.new
      @players       = Array.new(2) { |index| Player.new rand(width), color_palette.get("player_#{index}") }
      @terrain       = Terrain.new width, height, rand(10), color_palette.get('terrain')
      @mouse         = Mouse.new event_runner, players, terrain

      event_runner.subscribe Events::MousePressed,  &mouse.method(:mouse_pressed)
      event_runner.subscribe Events::MouseReleased, &mouse.method(:mouse_released)
      event_runner.subscribe Events::MouseMoved,    &mouse.method(:mouse_moved)
      event_runner.subscribe(Events::EntityCreated) { |event| entities << event.entity }
      event_runner.subscribe(Events::GameEnding)    { |event| event.time < Time.now ? setup : event_runner.publish(event) }
    end

    def update(delta)
      event_runner.process_events!

      radius = 50
      @entities.each { |entity| entity.update delta }
      @entities, @dead = *@entities.partition { |entity| terrain.fetch(entity.x, 0) < entity.y }
      @dead
        .select { |entity| entity.is_a? Shot }
        .select { |entity| entity.x < terrain.width && entity.x > 0 }
        .each   { |entity| terrain.bite entity.x, radius }
        .each   { |entity| event_runner.publish Events::EntityCreated.new(Explosion.new(entity.x, entity.y)) }
        .select { |entity| players.any? { |player| inside_radius? entity.x - player.x, 0, radius } }
        .each   { event_runner.publish Events::GameEnding.new(Time.now + 1) }
    end

    def render(graphics)
      graphics.set_color color_palette.get('sky')
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

    def publish(event)
      event_runner.publish event
    end
  end
end
