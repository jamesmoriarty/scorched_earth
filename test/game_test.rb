require 'test_helper'

describe ScorchedEarth::Game do
  before do
    @game = ScorchedEarth::Game.new(800, 600)

    @game.setup
  end

  it 'renders' do
    @game.publish ScorchedEarth::Events::MouseMoved.new(0, 0)

    @game.render graphics = NullObject.new
  end

  it 'fires when clicked' do
    @game.publish ScorchedEarth::Events::MouseMoved.new(0, 0)
    @game.publish ScorchedEarth::Events::MousePressed.new(0, 0)
    @game.publish ScorchedEarth::Events::MouseReleased.new(0, 0)

    @game.update(1)

    assert @game.objects.select { |object| object.is_a? ScorchedEarth::Shot }.size, 1
  end

  it 'changes player when mouse is released' do
    original_player = @game.current_player
    @game.publish ScorchedEarth::Events::MouseReleased.new(0, 0)

    @game.update(1)

    assert @game.current_player != original_player
  end
end
