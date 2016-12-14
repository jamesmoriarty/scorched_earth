require 'test_helper'

describe ScorchedEarth::Game do
  before do
    Color = Java::JavaAwt::Color # HACK
    @game = ScorchedEarth::Game.new(800, 600)
    @game.setup
  end

  it 'changes player when mouse is released' do
    original_player = @game.current_player
    @game.publish ScorchedEarth::Events::MouseMoved.new(0, 0)
    @game.publish ScorchedEarth::Events::MousePressed.new(0, 0)
    @game.publish ScorchedEarth::Events::MouseReleased.new(0, 0)
    @game.update(1)

    assert @game.current_player != original_player
  end
end

describe ScorchedEarth::Helpers do
  before do
    @subject = ScorchedEarth::Helpers
  end

  it('#angle')              { @subject.angle(1, 1).must_equal 45 }
  it('#radians_to_degrees') { @subject.radians_to_degrees(Math::PI).must_equal 180 }
  it('#degrees_to_radians') { @subject.degrees_to_radians(180).must_equal Math::PI }
  it('#offset_x')           { @subject.offset_x(45, 1).must_equal 0 }
  it('#offset_y')           { @subject.offset_y(45, 1).must_equal(-1) }
  it('#inside_radius?')     { @subject.inside_radius?(1, 1, 5) }
  it('#circle')             { @subject.circle(1).to_a.must_equal [[-1, 0.0], [0, 1.0], [1, 0.0]] }
end
