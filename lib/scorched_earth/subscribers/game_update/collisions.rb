module ScorchedEarth
  module Subscribers
    module Collisions
      def setup
        super

        event_runner.subscribe(Events::GameUpdate) do
          objects
            .select   { |entity| entity.is_a? Shot }
            .select   { |entity| array.fetch(entity.x, 0) > entity.y }
            .each     { |entity| event_runner.publish Events::Hit.new(entity, radius = 50) }
            .each     { |entity| objects << entity.trajectory }
            .each     { |entity| objects.delete entity }
        end
      end
    end
  end
end
