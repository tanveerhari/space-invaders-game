local AlienFleet = {}

Alien = require("game/Alien")

function AlienFleet.newFleet(start_x, start_y, end_x, end_y)
  fleet = {
    aliens = {},
    timer = 1,
    command = 0,
    bullets = {},
    left_x = start_x,
    no_left_move = false,
    right_x = end_x,
    no_right_move = false,
    chooseCommand = function(self, requests)
      command = 0
      if self.timer == 50 then
        command = math.random(1, 3)
        self.timer = 1
        if command == 1 and self.no_left_move then
          command = 2
          self.no_left_move = false
        elseif command == 2 and self.no_right_move then
          command = 1
          self.no_right_move = false
        end
      else
        self.timer = self.timer + 1
      end
      return command
    end,
    getShooter = function (self)
      shooter_index = math.random(1, table.getn(self.aliens[1]))
      j = table.getn(self.aliens)
      repeat
        shooter = self.aliens[j][shooter_index]
        j = j - 1
      until j > 0 or not shooter.isDirty
      return shooter
    end,
    update = function (self, requests)
      -- choose command
      -- idle = 0, shoot = 3, move_left = 1, move_right = 2
      self.command = self:chooseCommand()
      cmd = self.command
      if cmd == 3 then
        --shoot
        shooter = self:getShooter()
        if not shooter.isDirty then
          fleet_bullets = self.bullets
          shooter:shoot(fleet_bullets)
        end
      else
        for i = 1, table.getn(self.aliens), 1
        do
          for j = 1, table.getn(self.aliens[i]), 1
          do
            if not self.aliens[i][j].isDirty then
              self.aliens[i][j]:update(cmd, requests)
            end
          end
        end
      end
    end
  }
  for j = start_y, end_y, 1
   do
     fleet.aliens[j] = {}
     for i = start_x, end_x, 1
     do
       fleet.aliens[j][i] = Alien.newAlien(i, j)
     end
   end
  return fleet
end

return AlienFleet
