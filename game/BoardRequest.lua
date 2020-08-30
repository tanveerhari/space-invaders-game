local BoardRequest = {}

function BoardRequest.newRequestMap()
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

return BoardRequest
