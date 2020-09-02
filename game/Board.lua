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

function Board:resetRequestsMap()
	self.requests = self:newRequestMap()
end

-- method definitions
function Board:update()
  for k in pairs(self.requests.map)
  do
    v = requests.map[k]
    if self:isPointValid(v.point) then
      v.occupant:move(v.point)
    elseif v.occupant.type == "bullet" then
      v.occupant.is_dirty = true
    end
  end
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
      self.map[key] = {
        point = request_position,
        occupant = request_occupant
      }
    end
  }
end


return Board
