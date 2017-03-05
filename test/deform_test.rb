require 'test_helper'

describe ScorchedEarth::Services::Deform do
  it 'reduces' do
    assert_equal [10.0, 9.0, 10.0], ScorchedEarth::Services::Deform.new([10, 10, 10]).call(1, 1)
  end
end
