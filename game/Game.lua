Game = {}

SpaceShip = require("game/SpaceShip")
AlienFleet = require("game/AlienFleet")
Board = require("game/Board")

Game.__index = Game
--constructor
function Game.new(board_rows, board_cols)
	local instance = {
    is_in_play = true,
    score = 0,
    board = nil,--Board.new(board_rows, board_cols),
    player = nil,
    aliens_fleet = nil
	}

	-- set Game as prototype for the new instance
	setmetatable(instance, Game)
	--instance:load()
	print("new game")
	return instance
end

-- method definitions
function Game:load(board_rows, board_cols)
	self.board = Board.new(board_rows, board_cols)

	player_initial_x = math.floor(game.board.cols/2)
	player_initial_y = game.board.rows - 1
	initial_player_point = {x = player_initial_x, y = player_initial_y}
	self.player = SpaceShip.new(initial_player_point, "player", 3, "up")

	fleet_rows = math.floor(self.board.rows/4)
	fleets_cols = self.board.cols - 2
	initial_alien_point = {x = 2, y = 2}
	self.aliens_fleet = AlienFleet.new(initial_alien_point, fleet_rows, fleets_cols)
	self.aliens_fleet:loadAliens(initial_alien_point)
end

function Game:update()
	self.board:resetRequestsMap()
	requests = self.board.requests
	self.player:update(requests)
	self.aliens_fleet:update(requests)
	self.board:update()
end

return Game
