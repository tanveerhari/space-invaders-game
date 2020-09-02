Bullet = {}
BoardObject = require("game/BoardObject")

-- constructor
Bullet.__index = Bullet
function Bullet.new(shooter_position, opposing_direction)
	local instance = {
    position = shooter_position,
    type = "bullet",
    direction = opposing_direction,
    timer = 0
	}
	setmetatable(instance,Bullet)
	return instance
end

-- extends BoardObject
setmetatable(Bullet,{__index = BoardObject})

-- override
function Bullet:update(requests)
  if self.timer == 5 then
    --request move
    request_y = self.position.y - 0.5
    if self.direction == "down" then
      request_y = self.position.y + 0.5
    end
    request_point = {x = self.position.x, y = request_y}
    request_occupant = self
    requests:addRequest(request_point, request_occupant)
    self.timer = 0
  else
    --increment timer
    self.timer = self.timer + 1
  end
end

return Bullet
