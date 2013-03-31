class GameOver < Chingu::GameState
  def setup
    self.input = { :esc => :exit, :return => :try_again }
    @layover = Gosu::Color.new(0x22000000)
  end

  def draw
    super
    previous_game_state.draw
    fill(@layover)
    draw_text("GAME OVER", $window.height/8, 56)
    draw_text("ESC to quit, RETURN to try again!", $window.height/8*2, 42)
  end

  def draw_text(text, y, font_size)
    factor_x, factor_y = 1, 1

    @font     = Gosu::Font["minercraftory.ttf", font_size]
    # text      = "GAME OVER (ESC to quit, RETURN to try again!)"
    x         = ($window.width/2) - (@font.text_width(text, factor_x)/2)
    # y         = $window.height/8
    z         = 0

    color     = Gosu::Color::BLACK
    @font.draw(text, x-2, y+2, 500, factor_x, factor_y, color)

    color     = Gosu::Color::WHITE
    @font.draw(text, x, y, 500, factor_x, factor_y, color)
  end

  def try_again
    pop_game_state  # pop back to our playing game state
  end
end
