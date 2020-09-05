AlienFleet = {}

SpaceShip = require("game/SpaceShip")

AlienFleet.__index = AlienFleet
--constructor
function AlienFleet.new(initial_point, fleet_rows, fleets_cols)
	local instance = {
			alignment = "center",
      rows = fleet_rows,
      cols = fleets_cols,
      timer = 1,
			down_timer = 1,
			down_level = 15,
			shoot_frequency = 1,
			dirty_count = 0,
      -- idle, shoot, move_left, move_right, move_down
      commands = {"idle", "move_left", "move_right", "shoot", "move_down"},
      aliens = {}
	}

	-- set AlienFleet as prototype for the new instance
	setmetatable(instance, AlienFleet)
  --instance:loadAliens(initial_point)
	return instance
end

-- method definitions
function AlienFleet:loadAliens(initial_point)
  for i = 1, self.rows, 1
   do
     self.aliens[i] = {}
     for j = 1, self.cols, 1
     do
       alien_point = {x = initial_point.x + j - 1, y = initial_point.y + i - 1}
			 if self.aliens[i][j] == nil then
				 self.aliens[i][j] = SpaceShip.new(alien_point, "alien", 1, "down")
			 else
				 self.aliens[i][j]:upgrade(alien_point)
			 end
     end
   end
end

function AlienFleet:upgrade(initial_point, down_level, shoot_frequency)
	-- reset parameters
	self.dirty_count = 0
	self.timer = 1
	self.down_timer = 1
	self.alignment = "center"
	-- reset and upgrade aliens
	self:loadAliens(initial_point)

	--upgrade shoot and move_down frequencies
	self.down_level = down_level
	self.shoot_frequency = shoot_frequency
end

function AlienFleet:chooseCommand()
  index = 0
  if self.timer == 50 then
		if self.down_timer == self.down_level then
			index = 5
			self.down_timer = 1
		else
    	index = math.random(1, 4)
			self.down_timer = self.down_timer + 1
		end
		self.timer = 1
  else
    self.timer = self.timer + 1
  end
  return self.commands[index]
end

function AlienFleet:getShooter(exclude_index)
	repeat
		shooter_index = math.random(1, self.cols)
	until shooter_index ~= exclude_index
  j = self.rows
  repeat
    shooter = self.aliens[j][shooter_index]
    j = j - 1
  until j > 0 or not shooter.is_dirty
  return {alien = shooter, index = shooter_index}
end

function AlienFleet:shoot()
	exclude_index = 0
	for i = 1, self.shoot_frequency, 1
	do
  	shooter_info = self:getShooter(exclude_index)
		exclude_index = shooter_info.index
		shooter = shooter_info.alien
  	if not shooter.is_dirty then
    	shooter.state = "shoot"
    	shooter:update(requests)
  	end
	end
end

function AlienFleet:moveAliens(command)
	if (self.alignment == "left" and command == "move_left") or (self.alignment == "right" and command == "move_right") then
		--do nothing
		command = "idle"
	end
	for i = 1, self.rows, 1
  do
    for j = 1, self.cols, 1
    do
      alien = self.aliens[i][j]
			alien.state = command
      alien:update(requests)
    end
	end
end

function AlienFleet:updateAlignment(command)
	if command == "move_left" then
		if self.alignment == "center" then
			self.alignment = "left"
		elseif self.alignment == "right" then
			self.alignment = "center"
		end
	elseif command == "move_right" then
		if self.alignment == "center" then
			self.alignment = "right"
		elseif self.alignment == "left" then
			self.alignment = "center"
		end
	end
end

function AlienFleet:update()
  command = self:chooseCommand()
  if command == "shoot" then
    self:shoot()
  else
    self:moveAliens(command)
		self:updateAlignment(command)
  end
end

return AlienFleet
