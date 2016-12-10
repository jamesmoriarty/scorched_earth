require 'scorched_earth/event/hit'

module ScorchedEarth
  module Subscribers
    module Deform
      def setup
        super

        event_runner.subscribe(Event::Hit) do |event|
          if event.entity.x < terrain.size && event.entity.x > 0
            @terrain = Services::Deform.new(terrain).call(event.entity.x, event.radius)
            @players = players.map { |player| Player.new player.x, terrain[player.x], player.color }
          end
        end
      end
    end
  end
end
