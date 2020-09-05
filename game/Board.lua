Board = {}
Board.__index = Board
--constructor
function Board.new(board_rows, board_cols)
	local instance = {
    rows = board_rows,
    cols = board_cols,
    requests = nil
	}

	-- set Board as prototype for the new instance
	setmetatable(instance, Board)
	--instance.requests = instance:newRequestMap()
	return instance
end

-- method definitions
function Board:resetRequestsMap()
	self.requests = self:newRequestMap()
end

function Board:handleSingleOccupantRequest(request)
	if self:isPointValid(request.point) then
		request.occupants[1]:move(request.point)
		if request.occupants[1].type == "alien" then
			return {alien_fleet_down_level = request.occupants[1].position.y}
		end
	elseif request.occupants[1].type == "bullet" then
		request.occupants[1].is_dirty = true
	end
	return {alien_fleet_down_level = 0}
end

function Board:handleMultipleOccupantRequest(request)
	-- should we check for valid point?
	collision = ""
	for i = 1, table.getn(request.occupants), 1
	do
		occupant = request.occupants[i]
		print(occupant.type)
		if occupant.type == "bullet" then
			occupant.is_dirty = true
			collision = collision.."b"
		elseif occupant.type == "alien" then
			occupant.is_dirty = true
			collision = collision.."a"
		elseif occupant.type == "player" then
			occupant.lives = occupant.lives - 1
			collision = collision.."p"
		end
	end
	print("collision: "..collision)
	if collision == "ba" or collision == "ab" then
		-- increase player hits
		return {player_dirty = false, player_hits_gained = 1}
	elseif collision == "pa" or collision == "ap" then
		-- player is dirty
		return {player_dirty = true, player_hits_gained = 0}
	else
		return {player_dirty = false, player_hits_gained = 0}
	end
end

function Board:update()
	response = {
		player_dirty = false,
		player_hits_gained = 0,
		alien_fleet_down_level = 0
	}
  for k in pairs(self.requests.map)
  do
    v = requests.map[k]
		if table.getn(v.occupants) > 1 then
			-- collision
			r = self:handleMultipleOccupantRequest(v)
			self:updateMultipleOccupantResponse(response, r)
		else
			-- handle single request
			r = self:handleSingleOccupantRequest(v)
			self:updateSingleOccupantResponse(response, r)
		end
  end
	return response
end

function Board:updateSingleOccupantResponse(response, r)
	if response.alien_fleet_down_level < r.alien_fleet_down_level then
		response.alien_fleet_down_level = r.alien_fleet_down_level
	end
end

function Board:updateMultipleOccupantResponse(response, r)
	response.player_hits_gained = response.player_hits_gained + r.player_hits_gained
	response.player_dirty = response.player_dirty or r.player_dirty
end

function Board:isPointValid(point)
	--return true
  return point.x >= 1 and point.y >= 1 and point.x <= self.cols and point.y <= self.rows
end

function Board:newRequestMap()
  return{
    map = {},
    addRequest = function(self, request_position, request_occupant)
      key = request_position.x..":"..request_position.y
			if self.map[key] == nil then
				self.map[key] = {
					point = nil,
					occupants = {}
				}
				self.map[key].point = request_position
				table.insert(self.map[key].occupants, request_occupant)
			else
				table.insert(self.map[key].occupants, request_occupant)
			end

    end
  }
end

return Board
