local Bullet = {}

function Bullet.newBullet(shooter_x, shooter_y, dir)
  return {
    type = "bullet",
    position = {
      x = shooter_x,
      y = shooter_y
    },
    timer = 0,
    isDirty = false,
    direction = dir,
    update = function (self, requests)
      if self.timer == 5 then
        --request move
        --self.position.y = self.position.y - 0.5
        request_point = {x = self.position.x, y = self.position.y - 0.5}
        request_occupant = self
        requests:addRequest(request_point, request_occupant)
        self.timer = 0
      else
        --increment timer
        self.timer = self.timer + 1
      end
    end,
    move = function (self, point)
      self.position.x = point.x
      self.position.y = point.y
    end
  }
end

return Bullet
