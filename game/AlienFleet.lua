local AlienFleet = {}

Alien = require("game/Alien")

function AlienFleet.newFleet(start_x, start_y, end_x, end_y)
  fleet = {
    aliens = {},
    update = function (self, requests)
      --choose command
      command = 0
      i = 1
      while i <= table.getn(self.aliens)
      do
        -- if alien is dirty then remove it
        if self.aliens[i].isDirty then
          self.aliens[i] = game.aliens[table.getn(game.aliens)]
          table.remove(game.aliens)
        else
          self.aliens[i]:update(cmd, requests)
          i = i + 1
        end
      end
    end
  }
  for j = start_y, end_y, 1
   do
     for i = start_x, end_x, 1
     do
       alien = Alien.newAlien(i, j)
       table.insert(fleet.aliens, alien)
     end
  end
  return fleet
end

return AlienFleet
