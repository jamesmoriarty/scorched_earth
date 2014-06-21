module Scorched
  class GameScene < Ray::Scene
    attr_accessor :width, :height, :cycles, :terrian, :input_manager, :ui_manager

    scene_name :game

    def setup
      @width, @height = window.size.to_a
      @cycles         = rand(10)
      @terrian        = Terrian.new(width, height, cycles)
      @input_manager  = InputManager.new(self)
      @ui_manager      = UIManager.new(self)

      2.times { Player.create(terrian) }
    end

    def register
      add_hook :mouse_release, input_manager.method(:mouse_release)
      add_hook :mouse_press,   input_manager.method(:mouse_press)
      add_hook :quit,          method(:exit!)

      always do
        update
      end
    end

    def update
      Entity.descendants.each do |klass|
        klass.all.each(&:update)
      end

      update_input
      update_collisions
      update_scene
    end

    def render(win)
      Entity.descendants.each do |klass|
        klass.all.each do |entity|
          entity.render(win, height)
        end
      end

      terrian.render(win, height)
      ui_manager.render(win, height)
    end

    def cleanup
      Entity.descendants.each do |klass|
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
        cleanup
        setup
      end
    end

    def update_collisions
      Shot.all.each do |shot|
        if shot.x >= 0 && shot.x < width && shot.y <= terrian[shot.x]
          update_shots_do_remove_players(shot)
          terrian.deform(shot.x, shot.radius)
          shot.destroy
        end
      end
    end

    def update_shots_do_remove_players(shot)
      Player.all.select do |player|
        x = player.x - shot.x
        y = player.y - shot.y
        Math.inside_radius?(x, y, shot.radius)
      end.each(&:destroy)
    end

    def update_input
      if [:right, :d].any? { |code| holding? key(code) }
        current_player.x += 1
        current_player.x  = [current_player.x, width].min
      elsif [:left, :a].any? { |code| holding? key(code) }
        current_player.x -= 1
        current_player.x  = [current_player.x, 0].max
      end
    end
  end
end
