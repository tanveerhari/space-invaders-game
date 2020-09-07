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
		level = 1,
		initial_decision_limit = 50,
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
	--board
	self.board = Board.new(board_rows, board_cols)

	--player
	player_initial_x = math.floor(game.board.cols/2)
	player_initial_y = game.board.rows - 1
	initial_player_point = {x = player_initial_x, y = player_initial_y}
	self.player = SpaceShip.new(initial_player_point, "player", 3, "up")

	--alien fleet
	fleet_rows = math.floor(self.board.rows/4)
	fleets_cols = self.board.cols - 2
	initial_alien_point = {x = 2, y = 2}
	self.aliens_fleet = AlienFleet.new(initial_alien_point, fleet_rows, fleets_cols)
	self.aliens_fleet:loadAliens(initial_alien_point)
end

function Game:update()
	if game.is_in_play then
		self.board:resetRequestsMap()
		requests = self.board.requests
		self.player:update(requests)
		self.aliens_fleet:update(requests)
		response = self.board:update()
		self:updateGameState(response)
	end
end

function Game:updateGameState(response)
	--update alien dirty count
	self.aliens_fleet.dirty_count = self.aliens_fleet.dirty_count + response.alien_dirty_count
	--update score
	self.score = self.score + response.player_hits_gained
	--update game in play
	if self.player.is_dirty or self.player.lives <= 0 or response.alien_fleet_down_level >= self.player.position.y then
		self.is_in_play = false
	end
	--update game level
	--print("dirty count: "..self.aliens_fleet.dirty_count..","..(self.aliens_fleet.rows * self.aliens_fleet.cols))
	if self.is_in_play and self.aliens_fleet.dirty_count == (self.aliens_fleet.rows * self.aliens_fleet.cols) then
		self:upgradeLevel()
	end
end

function Game:upgradeLevel()
	--print("upgrading level")
	previous_level = self.level
	if self.level == 10 then
		self.level = 1
	else
		self.level = self.level + 1
	end
	print("level: "..self.level)
	-- reset and upgrade player and bullets
	player_initial_x = math.floor(game.board.cols/2)
	player_initial_y = game.board.rows - 1
	initial_player_point = {x = player_initial_x, y = player_initial_y}
	self.player:upgrade(initial_player_point)
	--self.player.lives = self.player.lives + 1
	self.score = self.score + previous_level

	-- reset and upgrade alien fleet, aliens and bullets
	initial_alien_point = {x = 2, y = 2}
	shoot_frequency = math.floor(self.level/2)
	if shoot_frequency <= 0 then
		shoot_frequency = 1
	end
	level_decision_limit = self.initial_decision_limit - ((self.level - 1) * 2)
	self.aliens_fleet:upgrade(initial_alien_point, level_decision_limit, shoot_frequency)
end

return Game
