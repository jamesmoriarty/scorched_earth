include Java

import java.awt.Color

require 'scorched_earth/objects/player'
require 'scorched_earth/objects/shot'
require 'scorched_earth/objects/explosion'
require 'scorched_earth/objects/mouse'
require 'scorched_earth/event_runner'
require 'scorched_earth/event/game_update'
require 'scorched_earth/event/subscribers/game_over/timeout'
require 'scorched_earth/event/subscribers/game_update/collisions'
require 'scorched_earth/event/subscribers/hit/deform'
require 'scorched_earth/event/subscribers/hit/effect'
require 'scorched_earth/event/subscribers/hit/radius'
require 'scorched_earth/event/subscribers/mouse_moved'
require 'scorched_earth/event/subscribers/mouse_pressed'
require 'scorched_earth/event/subscribers/mouse_released'
require 'scorched_earth/helpers'
require 'scorched_earth/services/color_palette'
require 'scorched_earth/services/deform'
require 'scorched_earth/services/renders'
require 'scorched_earth/services/wave'

module ScorchedEarth
  class Game
    include Helpers

    attr_reader :width, :height, :cache,
                :color_palette, :objects, :players, :terrain, :mouse,
                :event_runner

    [
      Event::Subscribers::MousePressed,
      Event::Subscribers::MouseReleased,
      Event::Subscribers::MouseMoved,
      Event::Subscribers::Timeout,
      Event::Subscribers::Collisions,
      Event::Subscribers::Deform,
      Event::Subscribers::Effect,
      Event::Subscribers::Radius
    ].each do |subscriber|
      prepend subscriber
    end

    def initialize(width, height)
      @width         = width
      @height        = height
      @mouse         = Mouse.new
    end

    def setup
      @cache         = {}
      @color_palette = Services::ColorPalette.new Color::RED, Color::YELLOW, Color::WHITE
      @event_runner  = EventRunner.new
      @objects       = []
      @terrain       = Services::Wave.new(width, height, phases = rand(10)).each.to_a # Array.new(width) { height / 4 }
      @players       = Array.new 2, &method(:new_player)
    end

    def update(delta)
      @objects = objects
                 .flat_map { |entity| entity.update delta }
                 .compact

      event_runner.publish Event::GameUpdate.new delta
      event_runner.process!
    end

    def render(graphics)
      graphics.set_color color_palette.get('sky')
      graphics.fill_rect 0, 0, width, height

      Services::Renders::Mouse.new(mouse, current_player).call(graphics)

      objects.each { |entity| Services::Renders.find(entity).call(graphics) }
      players.each { |player| Services::Renders.find(player).call(graphics) }

      Services::Renders::Array.new(terrain, color_palette.get('terrain'), cache).call(graphics)
    end

    def publish(event)
      event_runner.publish event
    end

    def current_player
      players.first
    end

    def next_player
      players.rotate!
    end

    def new_player(index, x = rand(width))
      Player.new x, terrain[x], color_palette.get("player_#{index}")
    end
  end
end
