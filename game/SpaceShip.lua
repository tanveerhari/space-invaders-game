SpaceShip = {}
BoardObject = require("game/BoardObject")
Bullet = require("game/Bullet")

-- constructor
SpaceShip.__index = SpaceShip
function SpaceShip.new(initial_point, ship_type, ship_lives, opposing_direction)
	local instance = {
    position = initial_point,
    type = ship_type,
    lives = ship_lives,
    -- idle, shoot, move_left, move_right, move_down
    state = "idle",
    bullets = {},
    shooting_direction = opposing_direction
	}
	setmetatable(instance, SpaceShip)
	return instance
end

-- extends BoardObject
setmetatable(SpaceShip,{__index = BoardObject})

function SpaceShip:upgrade(initial_point)
	self.position = initial_point
	self.is_dirty = false
	self.state = "idle"
	self:emptyBullets()
end

function SpaceShip:emptyBullets()
	count = table.getn(self.bullets)
	for i = 1, count, 1
	do
		bullet = table.remove(self.bullets)
		bullet = nil
	end
end

-- override
function SpaceShip:update(requests)
	if not self.is_dirty then
		self:updateState(requests)
	end
	self:updateBullets(requests)
end

function SpaceShip:shoot()
  table.insert(self.bullets, Bullet.new(self.position, self.shooting_direction))
end

function SpaceShip:updateState(requests)
	request_point = {x = self.position.x, y = self.position.y}
	if self.state == "move_left" then
    request_point = {x = self.position.x - 1, y = self.position.y}
    --request_occupant = self
    --requests:addRequest(request_point, request_occupant)
  elseif self.state == "move_right" then
    request_point = {x = self.position.x + 1, y = self.position.y}
    --request_occupant = self
    --requests:addRequest(request_point, request_occupant)
  elseif self.state == "move_down" then
    request_point = {x = self.position.x, y = self.position.y + 1}
    --request_occupant = self
    --requests:addRequest(request_point, request_occupant)
  elseif self.state == "shoot" then
    self:shoot()
  end
	--send request here
	request_occupant = self
	requests:addRequest(request_point, request_occupant)
  self.state = "idle"
end

function SpaceShip:updateBullets(requests)
  i = 1
  while i <= table.getn(self.bullets)
  do
    bullet = self.bullets[i]
    if bullet.is_dirty then
      --remove bullet
      self.bullets[i] = self.bullets[table.getn(self.bullets)]
      dirty_bullet = table.remove(self.bullets)
			dirty_bullet = nil
    else
      bullet:update(requests)
      i = i + 1
    end
  end
end

return SpaceShip
