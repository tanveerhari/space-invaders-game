local Alien = {}

Bullet = require("game/Bullet")

function Alien.newAlien(initial_x, initial_y)
  return {
    type = "alien",
    position = {
      x = initial_x,
      y = initial_y
    },
    isDirty = false,
    bullets = {},
    -- idle = 0, shoot = 3, move_left = 1, move_right = 2
    update = function (self, command, requests)
      if command == 1 then
        request_point = {x = self.position.x - 1, y = self.position.y}
        request_occupant = self
        requests:addRequest(request_point, request_occupant)
      elseif command == 2 then
        request_point = {x = self.position.x + 1, y = self.position.y}
        request_occupant = self
        requests:addRequest(request_point, request_occupant)
      elseif command == 3 then
        --check shootablitiy
        self:shoot()
      end
      command = 0
    end,
    move = function (self, point)
      self.position.x = point.x
      self.position.y = point.y
    end,
    shoot = function (self)
      table.insert(self.bullets, Bullet.newBullet(self.position.x, self.position.y, "down"))
    end
  }
end

return Alien
