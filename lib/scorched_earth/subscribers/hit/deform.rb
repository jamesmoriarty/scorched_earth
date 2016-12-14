require 'scorched_earth/events/hit'

module ScorchedEarth
  module Subscribers
    module Deform
      def setup
        super

        event_runner.subscribe(Events::Hit) do |event|
          if event.entity.x < array.size && event.entity.x > 0
            @array = Services::Deform.new(array).call(event.entity.x, event.radius)
            @players = players.map { |player| Player.new player.x, array[player.x] }
          end
        end
      end
    end
  end
end
