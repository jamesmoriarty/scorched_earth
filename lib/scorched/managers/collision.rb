require_relative "./manager"

module Scorched
  class Collision < Manager
    def update
      Shot.all.each do |shot|
        if collisison?(shot)
          terrian.deform(shot.x, shot.radius)
          remove_players(shot)
          shot.destroy
          Explosion.create(x: shot.x, y: shot.y)
        end
      end
    end

    private

    def collisison?(shot)
      shot.x >= 0 && shot.x < terrian.width && shot.y <= terrian[shot.x]
    end

    def remove_players(shot)
      Player.all.select do |player|
        Math.inside_radius?(player.x - shot.x, player.y - shot.y, shot.radius)
      end.each(&:destroy)
    end
  end
end
