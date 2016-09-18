require 'test_helper'

describe ScorchedEarth::GameScene do
  before do
    @game = Ray::Game.new("test")
    @game.scene(:game, ScorchedEarth::GameScene)
    @scene = @game.registered_scene(:game)
    @scene.register
    @scene.setup
  end

  it("#players") { @scene.players.size.must_equal 2 }
end

describe ScorchedEarth::Helpers do
  it("#angle")              { ScorchedEarth::Helpers.angle(1, 1).must_equal 45 }
  it("#radians_to_degrees") { ScorchedEarth::Helpers.radians_to_degrees(Math::PI).must_equal 180 }
  it("#degrees_to_radians") { ScorchedEarth::Helpers.degrees_to_radians(180).must_equal Math::PI }
  it("#offset_x")           { ScorchedEarth::Helpers.offset_x(45, 1).must_equal 0 }
  it("#offset_y")           { ScorchedEarth::Helpers.offset_y(45, 1).must_equal -1 }
end
