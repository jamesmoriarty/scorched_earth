class Play <  Chingu::GameState
  attr_accessor :terrain

  def initialize(options={})
    super

    self.terrain  = Terrain.new($window)
    self.input    = {
      [:q, :escape]         => proc { switch_game_state(Menu) },
      [:left, :a]           => proc { player.left; next_player },
      [:right, :d]          => proc { player.right; next_player },
      [:left_mouse_button]  => proc { player.try_fire(Gosu.angle(player.x, player.y, $window.mouse_x, $window.mouse_y)) and next_player }
    }
  end

  def setup
    Tank.destroy_all
    Shot.destroy_all
    @current_player_index = 0
    Tank.create(:x => $window.width/4*1, :y => 50)
    Tank.create(:x => $window.width/4*3, :y => 50)
  end

  def update
    # gravity
    Tank.all.each do |tank|
      tank.y += 2 unless terrain.collide_point?(tank.x, tank.y + 2)
    end

    Shot.all.each do |shot|
      if terrain.collide_point?(shot.x, shot.y)
        radius = 25
        terrain.remove_circle(shot.x, shot.y, radius)
        Tank.all.each do |tank|
          if Gosu.distance(tank.x, tank.y, shot.x, shot.y) < radius
            tank.destroy
          end
        end
        shot.destroy
      end
    end

    super

    push_game_state(GameOver) if Tank.size < 2
  end

  def draw
    fill(Gosu::Color.new(255,173,216,230))
    terrain.draw

    super

    if Tank.size > 0 && player
      draw_angle
      draw_pointer
    end
  end

  protected

  def draw_angle
    @font     = Gosu::Font.new($window, "verdana", 30)

    text      = "#{Gosu.angle(player.x, player.y, $window.mouse_x, $window.mouse_y).round}\xC2\xB0"
    x         = player.x - (@font.text_width(text)/2)
    y         = player.y - player.height * 2
    z         = 0
    factor_x, factor_y = 1, 1
    color     = Gosu::Color::BLACK

    @font.draw(text, x, y, z, factor_x, factor_y, color)
  end

  def draw_pointer
    $window.draw_line(
      $window.mouse_x,
      $window.mouse_y,
      Gosu::Color::RED,
      player.x,
      player.y + player.fire_y_offset,
      Gosu::Color.new(0,0,0,0),
      999
    )
  end

  def player
    Tank.all[@current_player_index] ? Tank.all[@current_player_index] : next_player
  end

  def next_player
    @current_player_index + 1 < Tank.size ? @current_player_index += 1 : @current_player_index = 0
  end

end
