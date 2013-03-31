class Play <  Chingu::GameState

  def setup
    self.input    = {
      [:esc, :q]            => :exit,
      [:left, :a]           => proc { player.left; next_player },
      [:right, :d]          => proc { player.right; next_player },
      [:left_mouse_button]  => proc { player.try_fire(Gosu.angle(player.x, player.y, $window.mouse_x, $window.mouse_y)) and next_player }
    }

    # cleanup old game objects
    Tank.destroy_all
    Shot.destroy_all
    Smoke.destroy_all
    Explosion.destroy_all

    # generate new terrain
    Terrain.instance.generate

    # player 1
    x = rand(0..$window.width / 4)
    Tank.create(:x => x, :y => Terrain.instance.highest_collide_point(x))

    # player 2
    x = rand(($window.width / 4 * 3)..$window.width)
    Tank.create(:x => x, :y => Terrain.instance.highest_collide_point(x))

    # rand player start
    @current_player_index = rand(1..Tank.size)
  end

  def update
    # gravity
    Tank.all.each do |tank|
      tank.y += 2 unless Terrain.instance.collide_point?(tank.x, tank.y + 2)
    end

    # direct hits
    [Tank].each_collision(Shot) do |tank, shot|
      shot.destroy
      Explosion.create(:x => shot.x, :y => shot.y)
      push_game_state(GameOver)
    end

    # terrain hits
    Shot.all.each do |shot|
      if Terrain.instance.collide_point?(shot.x, shot.y)
        radius = 25
        Terrain.instance.remove_circle(shot.x, shot.y, radius)
        Explosion.create(:x => shot.x, :y => shot.y)
        shot.destroy
      end
    end

    super
  end

  def draw
    fill(Gosu::Color.new(255,173,216,230))
    Terrain.instance.draw

    super

    if $window.current_game_state.class == self.class && player
      draw_angle
      draw_pointer
    end
  end

  protected

  def draw_angle
    @font     = Gosu::Font["minercraftory.ttf", 28]

    text      = "#{Gosu.angle(player.x, player.y, $window.mouse_x, $window.mouse_y).round}\xC2\xB0"
    x         = player.x - (@font.text_width(text)/2)
    y         = player.y - player.height - 50
    z         = 0
    factor_x, factor_y = 1, 1

    color     = Gosu::Color::BLACK
    @font.draw(text, x-2, y+2, z, factor_x, factor_y, color)

    color     = Gosu::Color::WHITE
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
