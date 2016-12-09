
require 'scorched_earth/services/renders/explosion'
require 'scorched_earth/services/renders/mouse'
require 'scorched_earth/services/renders/player'
require 'scorched_earth/services/renders/shot'
require 'scorched_earth/services/renders/array'

module ScorchedEarth
  module Services
    module Renders
      def self.find(object)
        class_name   = object.class.name.split('::').last
        render_class = const_get "ScorchedEarth::Services::Renders::#{class_name}"

        render_class.new(object)
      end
    end
  end
end
