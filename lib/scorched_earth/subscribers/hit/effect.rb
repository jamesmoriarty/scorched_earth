require 'scorched_earth/events/hit'

module ScorchedEarth
  module Subscribers
    module Effect
      def setup
        super

        event_runner.subscribe(Events::Hit) do |event|
          objects << Explosion.new(event.entity.x, event.entity.y)
        end
      end
    end
  end
end
