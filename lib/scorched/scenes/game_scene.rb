module Scorched
  class GameScene < Ray::Scene
    attr_accessor :width, :height, :cycles, :terrian

    scene_name :game

    def setup
      @width, @height = window.size.to_a
      @cycles         = rand(10)
      @terrian        = Terrian.new(width, height, cycles)

      Input.create(self)
      Collision.create(self)
      UI.create(self)

      2.times { Player.create(terrian: terrian) }
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
      [Entity, Manager].each do |klass|
        klass.descendants.each do |klass|
          klass.all.each(&:update)
        end
      end

      update_scene
    end

    def render(win)
      win.clear Ray::Color.new(153, 153, 204)

      [Entity, Manager].each do |klass|
        klass.descendants.each do |klass|
          klass.all.each do |entity|
            entity.render(win, height)
          end
        end
      end

      terrian.render(win, height)
    end


    def cleanup
      [Entity, Manager].each do |klass|
        klass.descendants.each do |klass|
          klass.all.each(&:destroy)
        end
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
