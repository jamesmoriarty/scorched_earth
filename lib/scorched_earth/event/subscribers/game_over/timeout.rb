require 'scorched_earth/event/game_over'

module ScorchedEarth
  module Event
    module Subscribers
      module Timeout
        def setup
          super

          event_runner.subscribe(Event::GameOver) do |event|
            event.time < Time.now ? setup : event_runner.publish(event)
          end
        end
      end
    end
  end
end
