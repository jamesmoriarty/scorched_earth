require 'scorched_earth/event/hit'

module ScorchedEarth
  module Event
    module Subscribers
      module Radius
        def setup
          super

          event_runner.subscribe(Event::Hit) do |event|
            if players.any? { |player| inside_radius? event.entity.x - player.x, 0, event.radius }
              event_runner.publish Event::GameOver.new(Time.now + 0.25)
            end
          end
        end
      end
    end
  end
end
