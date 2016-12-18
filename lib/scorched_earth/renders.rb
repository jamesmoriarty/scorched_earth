require 'scorched_earth/renders/explosion'
require 'scorched_earth/renders/mouse'
require 'scorched_earth/renders/player'
require 'scorched_earth/renders/shot'
require 'scorched_earth/renders/map'

module ScorchedEarth
  module Renders
    def self.find(object)
      class_name   = object.class.name.split('::').last
      render_class = const_get class_name

      render_class.new object
    end
  end
end
