include Java

import java.awt.Color

require 'scorched_earth/objects/player'
require 'scorched_earth/objects/shot'
require 'scorched_earth/objects/explosion'
require 'scorched_earth/objects/mouse'
require 'scorched_earth/event_runner'
require 'scorched_earth/event/game_update'
require 'scorched_earth/subscribers/game_over/timeout'
require 'scorched_earth/subscribers/game_update/collisions'
require 'scorched_earth/subscribers/hit/deform'
require 'scorched_earth/subscribers/hit/effect'
require 'scorched_earth/subscribers/hit/radius'
require 'scorched_earth/subscribers/mouse_moved'
require 'scorched_earth/subscribers/mouse_pressed'
require 'scorched_earth/subscribers/mouse_released/fire'
require 'scorched_earth/subscribers/mouse_released/next_player'
require 'scorched_earth/helpers'
require 'scorched_earth/services/color_palette'
require 'scorched_earth/services/deform'
require 'scorched_earth/renders'
require 'scorched_earth/services/wave'

module ScorchedEarth
  class Game
    include Helpers

    Subscribers.constants.each { |name| prepend Subscribers.const_get name }

    attr_reader :width, :height, :mouse,
                :event_runner, :color_palette, :objects, :players, :array


    def initialize(width, height)
      @width  = width
      @height = height
      @mouse  = Mouse.new
    end

    def setup
      @color_palette = Services::ColorPalette.new Color::RED, Color::YELLOW, Color::WHITE
      @event_runner  = EventRunner.new
      @objects       = []
      @array         = Services::Wave.new(width, height, phases = rand(10)).each.to_a # Array.new(width) { height / 4 }
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

      Renders::Mouse.new(mouse, current_player).call(graphics, color_palette)

      objects.each { |entity| Renders.find(entity).call(graphics, color_palette) }
      players.each { |player| Renders.find(player).call(graphics, color_palette) }

      Renders::Array.new(array).call(graphics, color_palette)
    end

    def publish(event)
      event_runner.publish event
    end

    def current_player
      players.first
    end

    def next_player!
      @players = players.rotate!
    end

    def new_player(index, x = rand(width))
      Player.new x, array[x]
    end
  end
end
