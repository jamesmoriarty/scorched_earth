require 'scorched_earth/event/hit'

module ScorchedEarth
  module Event
    module Subscribers
      module Effect
        def setup
          super

          event_runner.subscribe(Event::Hit) do |event|
            objects << Explosion.new(event.entity.x, event.entity.y)
          end
        end
      end
    end
  end
end
