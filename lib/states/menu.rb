class Menu < Chingu::GameState
  def setup
    Chingu::SimpleMenu.create(
      :size       => 96,
      :y          => 100,
      :menu_items => {
        "Play"        => Play,
        "Exit"        => :exit,
      },
    )
  end
end
