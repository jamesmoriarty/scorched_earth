module Scorched
  class GameScene < Ray::Scene
    attr_accessor :width, :height, :cycles, :terrian, :input_manager

    scene_name :game

    def setup
      @width, @height = window.size.to_a
      @cycles         = rand(10)
      @terrian        = self.class.random_terrian(width, height, cycles)
      @input_manager  = InputManager.new(self)
      2.times.map { Player.create(terrian) }
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

      update_player
      update_shots
      update_scene
    end

    def render(win)
      render_terrian(win)
      render_players(win)
      render_shots(win)
      render_explosions(win)
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

    def self.random_terrian(width, height, cycles)
      Array.new(width) do |index|
        Math.sin(index.to_f / width.to_f * cycles.to_f) * height / 4 + (height / 4).to_i
      end
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

    def update_shots
      Shot.all.each do |shot|
        if shot.x >= 0 && shot.x < width && shot.y <= terrian[shot.x]
          update_shots_do_remove_players(shot)
          update_shots_do_remove_terrian(shot)
          shot.destroy
          Explosion.create(x: shot.x, y: shot.y)
        end
      end
    end

    def update_shots_do_remove_terrian(shot)
      x1 = shot.x - shot.radius
      x1 = [0, x1].max.to_i
      x2 = shot.x + shot.radius
      x2 = [width, x2].min.to_i

      Range.new(x1, x2).to_a.each do |x|
        cycle       = (x - shot.x).to_f / (shot.radius * 2).to_f + 0.5
        delta       = Math.sin(Math::PI * cycle) * shot.radius
        terrian[x] -= delta.to_i if x >= 0 && x < width
      end
    end

    def update_shots_do_remove_players(shot)
      Player.all.select do |player|
        (player.x - shot.x) ** 2 + (player.y - shot.y) ** 2 < shot.radius ** 2
      end.each(&:destroy)
    end

    def update_player
      if [:right, :d].any? { |code| holding? key(code) }
        current_player.x += 1
        current_player.x  = [current_player.x, width].min
      elsif [:left, :a].any? { |code| holding? key(code) }
        current_player.x -= 1
        current_player.x  = [current_player.x, 0].max
      end
    end

    def render_terrian(win)
      terrian.each_with_index do |y, x|
        win.draw Ray::Polygon.line([x, height], [x, height - y], 1, Ray::Color.brown)
      end
    end

    def render_players(win)
      Player.all.each do |player|
        x, y = player.x, height - player.y
        win.draw Ray::Polygon.circle([x, y], 10, player.color)
        if current_player.eql?(player)
          win.draw Ray::Polygon.line([x, y], mouse_pos, 2, Ray::Color.red)
        end
      end
    end

    def render_shots(win)
      Shot.all.each do |shot|
        x1, y1 = shot.x, height - shot.y
        x2, y2 = x1 + Math.offsetX(shot.angle, 10), y1 + Math.offsetY(shot.angle, 10)
        win.draw Ray::Polygon.line([x1, y1], [x2, y2], 2, Ray::Color.yellow)
      end
    end

    def render_explosions(win)
      Explosion.all.each do |explosion|
        win.draw Ray::Polygon.circle([explosion.x, height - explosion.y], explosion.radius, Ray::Color.yellow)
      end
    end
  end
end
