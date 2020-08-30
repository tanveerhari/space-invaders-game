local Player = {}

Bullet = require("game/Bullet")

function Player.newPlayer(initial_x, initial_y)
  return {
    type = "bullet",
    position = {
      x = initial_x,
      y = initial_y
    },
    -- idle, shoot, move_left, move_right
    state = "idle",
    bullets = {},
    update = function (self, requests)
      if self.state == "move_left" then
        request_point = {x = self.position.x - 1, y = self.position.y}
        request_occupant = self
        requests:addRequest(request_point, request_occupant)
        self.state = "idle"
      elseif self.state == "move_right" then
        request_point = {x = self.position.x + 1, y = self.position.y}
        request_occupant = self
        requests:addRequest(request_point, request_occupant)
        self.state = "idle"
      elseif self.state == "shoot" then
        self:shoot()
        self.state = "idle"
      end
    end,
    move = function (self, point)
      self.position.x = point.x
      self.position.y = point.y
    end,
    shoot = function (self)
      table.insert(self.bullets, Bullet.newBullet(self.position.x, self.position.y, "up"))
    end
  }
end

return Player
