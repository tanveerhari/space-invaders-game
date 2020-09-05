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
       self.aliens[i][j] = SpaceShip.new(alien_point, "alien", 1, "down")
     end
   end
end

function AlienFleet:chooseCommand()
  index = 0
  if self.timer == 50 then
		if self.down_timer == 5 then
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

function AlienFleet:getShooter()
  shooter_index = math.random(1, self.cols)
  j = self.rows
  repeat
    shooter = self.aliens[j][shooter_index]
    j = j - 1
  until j > 0 or not shooter.is_dirty
  return shooter
end

function AlienFleet:shoot()
  shooter = self:getShooter()
  if not shooter.is_dirty then
    shooter.state = "shoot"
    shooter:update(requests)
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
