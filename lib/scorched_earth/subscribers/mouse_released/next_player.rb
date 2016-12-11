module ScorchedEarth
  module Subscribers
    module NextPlayer
      def setup
        super

        event_runner.subscribe(Event::MouseReleased) do |_event|
          next_player!
        end
      end
    end
  end
end
