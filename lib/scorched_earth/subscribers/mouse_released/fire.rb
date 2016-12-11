module ScorchedEarth
  module Subscribers
    module Fire
      def setup
        super

        event_runner.subscribe(Event::MouseReleased) do |event|
          if mouse.pressed_at
            delta      = (Time.now - mouse.pressed_at) * 1000 + 1000
            degrees    = angle(height - current_player.y - event.y, current_player.x - event.x) + 180
            velocity_x = offset_x(degrees, delta)
            velocity_y = offset_y(degrees, delta)
            shot       = Shot.new current_player.x, terrain[current_player.x], velocity_x, velocity_y

            objects << shot
          end
        end
      end
    end
  end
end
