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
	elseif request.occupants[1].type == "bullet" then
		request.occupants[1].is_dirty = true
	end
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
		return {player_dirty = false, player_lives_lost = 0, player_hits_gained = 1}
	elseif collision == "bp" or collision == "pb" then
		-- decrease player lives
		return {player_dirty = false, player_lives_lost = 1, player_hits_gained = 0}
	elseif collision == "ba" or collision == "ab" then
		-- player is dirty
		return {player_dirty = true, player_lives_lost = 0, player_hits_gained = 0}
	end
end

function Board:update()
	response = {
		player_dirty = false,
		player_lives_lost = 0,
		player_hits_gained = 0
	}
  for k in pairs(self.requests.map)
  do
    v = requests.map[k]
		if table.getn(v.occupants) > 1 then
			-- collision
			r = self:handleMultipleOccupantRequest(v)
			self:updateResponse(response, r)
		else
			-- handle single request
			self:handleSingleOccupantRequest(v)
		end
  end
	return response
end

function Board:updateResponse(response, r)
	response.player_lives_lost = response.player_lives_lost + r.player_lives_lost
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
      -- self.map[key] = {
      --   point = request_position,
      --   occupant = request_occupant
      -- }
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
