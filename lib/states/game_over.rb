class GameOver < Chingu::GameState
  def setup
    self.input = { :esc => Menu, :return => :try_again }
    @layover = Gosu::Color.new(0x99000000)
  end

  def draw
    super
    previous_game_state.draw
    fill(@layover)
    draw_text
  end

  def draw_text
    @font     = Gosu::Font.new($window, "verdana", 30)

    text      = "GAME OVER (ESC to quit, RETURN to try again!)"
    x         = ($window.width/2) - (@font.text_width(text)/2)
    y         = $window.height/2
    z         = 0
    factor_x, factor_y = 1, 1
    color     = Gosu::Color::WHITE

    @font.draw(text, x, y, z, factor_x, factor_y, color)
  end

  def try_again
    pop_game_state  # pop back to our playing game state
    pop_game_state  # old game
    push_game_state Play
  end
end
