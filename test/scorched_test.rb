require 'test_helper'

describe Scorched::GameScene do
  before do
    @game = Ray::Game.new("test")
    @game.scene(:game, Scorched::GameScene)
    @scene = @game.registered_scene(:game)
    @scene.register
    @scene.setup
  end

  it("#players") { @scene.players.size.must_equal 2 }
end

describe Scorched::Helpers do
  it("#angle")              { Scorched::Helpers.angle(1, 1).must_equal 45 }
  it("#radians_to_degrees") { Scorched::Helpers.radians_to_degrees(Math::PI).must_equal 180 }
  it("#degrees_to_radians") { Scorched::Helpers.degrees_to_radians(180).must_equal Math::PI }
  it("#offset_x")           { Scorched::Helpers.offset_x(45, 1).must_equal 0 }
  it("#offset_y")           { Scorched::Helpers.offset_y(45, 1).must_equal -1 }
end
