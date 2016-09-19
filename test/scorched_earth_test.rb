require 'test_helper'

describe ScorchedEarth::GameScene do
  before do
    @game = Ray::Game.new("test")
    @game.scene(:game, ScorchedEarth::GameScene)
    @scene = @game.registered_scene(:game)
    @scene.setup
    @scene.register
  end

  it("#players") { @scene.players.size.must_equal 2 }
end

describe ScorchedEarth::Terrain do
  before do
    @width   = 10
    @height  = 10
    @cycles  = 0
    @color   = nil
    @subject = ScorchedEarth::Terrain.new(@width, @height, @cycles, @color)
  end

  it("#[]")    { @subject[5].must_equal 2 }
  it("#width") { @subject.width.must_equal 10 }
  it("#bite")  { @subject.bite(5, 1); @subject[5].must_equal 1  }
end

describe ScorchedEarth::Helpers do
  before do
    @subject = ScorchedEarth::Helpers
  end

  it("#angle")              { @subject.angle(1, 1).must_equal 45 }
  it("#radians_to_degrees") { @subject.radians_to_degrees(Math::PI).must_equal 180 }
  it("#degrees_to_radians") { @subject.degrees_to_radians(180).must_equal Math::PI }
  it("#offset_x")           { @subject.offset_x(45, 1).must_equal 0 }
  it("#offset_y")           { @subject.offset_y(45, 1).must_equal -1 }
  it("#inside_radius?")     { @subject.inside_radius?(1, 1, 5) }
  it("#circle")             { result = []; @subject.circle(1) { |x, y| result << [x, y] }; result.must_equal [[-1, 0.0], [0, 1.0], [1, 0.0]] }
end
