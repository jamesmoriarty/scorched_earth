module ScorchedEarth
  module Event
    module Subscribers
      module MouseReleased
        def setup
          super

          event_runner.subscribe(Event::MouseReleased) do |_event|
            if mouse.pressed_at && mouse.x && mouse.y
              delta      = (Time.now - mouse.pressed_at) * 1000 + 1000
              degrees    = angle(height - current_player.y - mouse.y, current_player.x - mouse.x) + 180
              velocity_x = offset_x(degrees, delta)
              velocity_y = offset_y(degrees, delta)
              shot       = Shot.new current_player.x, terrain[current_player.x], velocity_x, velocity_y

              objects << shot

              next_player
            end
          end
        end
      end
    end
  end
end
