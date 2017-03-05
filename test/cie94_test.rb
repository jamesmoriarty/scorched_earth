require 'test_helper'

describe ScorchedEarth::Services::CIE94 do
  Color = Java::JavaAwt::Color # HACK

  it 'can tell colors are the same' do
    assert_equal 0, ScorchedEarth::Services::CIE94.new.call(Color.black, Color.black)
  end

  it 'can tell colors are different' do
    assert_equal 9341.57053391457, ScorchedEarth::Services::CIE94.new.call(Color.black, Color.white)
  end
end
