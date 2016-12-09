include Java

import java.awt.Color

require 'scorched_earth/entities/player'
require 'scorched_earth/entities/shot'
require 'scorched_earth/entities/explosion'
require 'scorched_earth/entities/mouse'
require 'scorched_earth/event_runner'
require 'scorched_earth/events/hit'
require 'scorched_earth/events/game_update'
require 'scorched_earth/events/game_over'
require 'scorched_earth/helpers'
require 'scorched_earth/services/color_palette'
require 'scorched_earth/services/deform'
require 'scorched_earth/services/renders'
require 'scorched_earth/services/wave'

module ScorchedEarth
  class Game
    include Helpers

    attr_reader :width, :height, :cache,
                :color_palette, :entities, :players, :terrain, :mouse,
                :event_runner

    def initialize(width, height)
      @width  = width
      @height = height
    end

    def setup
      @cache         = {}
      @mouse         = Mouse.new
      @color_palette = Services::ColorPalette.new Color::RED, Color::YELLOW, Color::WHITE
      @entities      = []
      @event_runner  = EventRunner.new
      @terrain       = Services::Wave.new(width, height, phases = rand(10)).each.to_a # Array.new(width) { height / 4 }
      @players       = Array.new(2) { |index, x = rand(width)| Player.new x, terrain[x], color_palette.get("player_#{index}") }

      register_events
    end

    def update(delta)
      @entities = entities
                  .flat_map { |entity| entity.update delta }
                  .compact

      event_runner.publish Events::GameUpdate.new delta
      event_runner.process!
    end

    def render(graphics)
      graphics.set_color color_palette.get('sky')
      graphics.fill_rect 0, 0, width, height

      Services::Renders::Mouse.new(mouse, current_player).call(graphics)

      entities.each { |entity| Services::Renders.find(entity).call(graphics) }
      players.each  { |player| Services::Renders.find(player).call(graphics) }

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

    private

    def register_events
      event_runner.subscribe Events::MousePressed,  &method(:do_mouse_pressed)
      event_runner.subscribe Events::MouseReleased, &method(:do_mouse_released)
      event_runner.subscribe Events::MouseMoved,    &method(:do_mouse_moved)
      event_runner.subscribe Events::GameOver,      &method(:do_game_over)
      event_runner.subscribe Events::GameUpdate,    &method(:do_game_update_collisions)
      event_runner.subscribe Events::Hit,           &method(:do_hit_deform)
      event_runner.subscribe Events::Hit,           &method(:do_hit_explode)
      event_runner.subscribe Events::Hit,           &method(:do_hit_check_radius)
    end

    def do_game_update_collisions(_event)
      entities
        .select   { |entity| entity.is_a? Shot }
        .select   { |entity| terrain.fetch(entity.x, 0) > entity.y }
        .each     { |entity| event_runner.publish Events::Hit.new(entity, radius = 50) }
        .each     { |entity| entities.delete entity}
    end

    def do_game_over(event)
      event.time < Time.now ? setup : event_runner.publish(event)
    end

    def do_mouse_released(_event)
      return unless mouse.pressed_at && mouse.x && mouse.y

      delta      = (Time.now - mouse.pressed_at) * 1000 + 1000
      degrees    = angle(height - current_player.y - mouse.y, current_player.x - mouse.x) + 180
      velocity_x = offset_x(degrees, delta)
      velocity_y = offset_y(degrees, delta)
      shot       = Shot.new current_player.x, terrain[current_player.x], velocity_x, velocity_y

      entities << shot

      next_player
    end

    def do_mouse_pressed(_event)
      @mouse = Mouse.new mouse.x, mouse.y, Time.now
    end

    def do_mouse_moved(event)
      @mouse = Mouse.new event.x, event.y, mouse.pressed_at
    end

    def do_hit_deform(event)
      return unless event.entity.x < terrain.size && event.entity.x > 0

      @terrain = Services::Deform.new(terrain).call(event.entity.x, event.radius)
      @players = players.map { |player| Player.new player.x, terrain[player.x], player.color }
    end

    def do_hit_explode(event)
      entities << Explosion.new(event.entity.x, event.entity.y)
    end

    def do_hit_check_radius(event)
      return unless players.any? { |player| inside_radius? event.entity.x - player.x, 0, event.radius }

      event_runner.publish Events::GameOver.new(Time.now + 0.25)
    end
  end
end
