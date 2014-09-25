require "terrain"
require "entities/player"
require "entities/shot"
require "entities/explosion"
require "components/input"
require "components/ui"
require "components/collision"

module Scorched
  class GameScene < Ray::Scene
    attr_accessor :width, :height, :cycles, :terrain

    scene_name :game

    def setup
      @width, @height = window.size.to_a
      @cycles         = rand(10)
      @terrain        = Terrain.new(width, height, cycles)

      [Input, Collision, UI].each { |klass| klass.create(self) }

      2.times { Player.create(terrain: terrain) }
    end

    def register
      add_hook :mouse_release, Input.get.method(:mouse_release)
      add_hook :mouse_press,   Input.get.method(:mouse_press)
      add_hook :quit,          method(:exit!)

      always do
        update
      end
    end

    def update
      GameObject.descendants.each do |klass|
        klass.all.each(&:update)
      end

      update_scene
    end

    def render(win)
      win.clear Ray::Color.new(153, 153, 204)

      GameObject.descendants.each do |klass|
        klass.all.each do |entity|
          entity.render(win, height)
        end
      end

      terrain.render(win, height)
    end


    def cleanup
      GameObject.descendants.each do |klass|
        klass.all.each(&:destroy)
      end
    end

    def next_player
      Player.all.rotate!
    end

    def current_player
      Player.all[0]
    end

    def mouse_pos
      super
    end

    private

    def update_scene
      if Player.all.size <= 1
        @timeout ||= Time.now.to_i + 1
        if @timeout.to_i <= Time.now.to_i
          cleanup
          setup
          @timeout = nil
        end
      end
    end
  end
end
