class Play <  Chingu::GameState

  def setup
    self.input    = {
      [:esc, :q]            => :exit,
      [:left, :a]           => proc { player.left; next_player },
      [:right, :d]          => proc { player.right; next_player },
      [:released_left_mouse_button] => proc do
        player.try_fire(player_angle, player_power);
        @mouse_down_at = nil
        next_player
      end,
      [:left_mouse_button] => proc {
        @mouse_down_at = Time.now
      }
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
    # remove off screen objects
    game_objects.destroy_if { |game_object| game_object.y > $window.height}
    push_game_state(GameOver) if Tank.size < 2


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
        radius = 50
        Terrain.instance.remove_circle(shot.x, shot.y, radius)
        Explosion.create(:x => shot.x, :y => shot.y)
        Tank.all.each do |tank|
          if Gosu.distance(tank.x, tank.y, shot.x, shot.y) < radius
            tank.destroy
            push_game_state(GameOver)
          end
        end
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
      draw_power
      draw_pointer
    end
  end

  protected

  def draw_power
    @font     = Gosu::Font["minercraftory.ttf", 28]

    power     = (player_power*10).round
    text      = "#{power}\u21E1"
    x         = player.x - player.width/2
    y         = player.y - player.height - 50
    z         = 0
    factor_x, factor_y = 1, 1

    color     = Gosu::Color::BLACK
    @font.draw(text, x-2, y+2, z, factor_x, factor_y, color)

    color = if power < 10
      Gosu::Color::RED
    elsif power < 20
      Gosu::Color::YELLOW
    else
      Gosu::Color::WHITE
    end

    @font.draw(text, x, y, z, factor_x, factor_y, color)
  end


  def draw_angle
    @font     = Gosu::Font["minercraftory.ttf", 28]

    text      = "#{player_angle.round}\xC2\xB0"
    x         = player.x + player.width/2
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

  def player_angle
    Gosu.angle(player.x, player.y, $window.mouse_x, $window.mouse_y)
  end

  def player_power
    (Time.now - (@mouse_down_at || Time.now)).to_f
  end

end
