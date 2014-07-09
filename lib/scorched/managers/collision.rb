require_relative "./manager"

module Scorched
  class Collision < Manager
    def update
      Shot.all.each do |shot|
        if collisison?(shot)
          remove_players(shot)
          remove_terrian(shot)
          remove_shot(shot)
        end
      end
    end

    private

    def collisison?(shot)
      shot.x >= 0 && shot.x < terrian.width && shot.y < terrian[shot.x]
    end

    def remove_terrian(shot)
      terrian.deform(shot.x, shot.radius)
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
