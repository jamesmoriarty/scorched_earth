require "components/component"

module Scorched
  class Collision < Component
    def update
      Shot.all.each do |shot|
        if collisison?(shot)
          remove_players(shot)
          remove_terrain(shot)
          remove_shot(shot)
        end
      end
    end

    private

    def collisison?(shot)
      shot.x >= 0 && shot.x < terrain.width && shot.y < terrain[shot.x]
    end

    def remove_terrain(shot)
      terrain.deform(shot.x, shot.radius)
    end

    def remove_players(shot)
      Player.all.select do |player|
        Math.inside_radius?(player.x - shot.x, player.y - shot.y, shot.radius)
      end.each(&:destroy)
    end

    def remove_shot(shot)
      shot.destroy
      Explosion.create(x: shot.x, y: shot.y)
    end
  end
end
