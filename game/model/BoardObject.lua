-- prototype table for board objects
BoardObject = {}
BoardObject.__index = BoardObject
--constructor
function BoardObject.new(initial_point, object_type)
	local instance = {
		is_dirty = false,
		position = initial_point,
    type = object_type
	}

	-- set BoardObject as prototype for the new instance
	setmetatable(instance, BoardObject)
	return instance
end

-- method definitions
function BoardObject:move(point)
	self.position = point
end

function BoardObject:update(requests)
end

return BoardObject
