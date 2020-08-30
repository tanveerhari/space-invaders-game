local game = {}

Player = require("game/Player")
BoardRequest = require("game/BoardRequest")

game.board_x = 0
game.board_y = 0
game.board_rows = 12
game.board_cols = 15

game.requests = 0

mid_x = (game.board_cols - game.board_x)/2
player_initial_x = math.floor(mid_x)
player_initial_y = game.board_rows - 1

game.player = Player.newPlayer(player_initial_x, player_initial_y)

function game.update()
  requests = BoardRequest.newRequestMap()
  game.player:update(requests)
  updatePlayerBullets(requests)
  updateBoard(requests)
end

function updateBoard(requests)
  for k in pairs(requests.map)
  do
    v = requests.map[k]
    if isPointWithinBoard(v.point) then
      v.occupant:move(v.point)
    elseif v.occupant.type == "bullet" then
      v.occupant.isDirty = true
    end
  end
end

function isPointWithinBoard(point)
  return point.x >= game.board_x and point.y >= game.board_y and  point.x < game.board_cols and point.y < game.board_rows
end

function updatePlayerBullets()
  --for i = 1, table.getn(game.player.bullets), 1
  i = 1
  while i <= table.getn(game.player.bullets)
  do
    bullet = game.player.bullets[i]
    if bullet.isDirty then
      --remove bullet
      game.player.bullets[i] = game.player.bullets[table.getn(game.player.bullets)]
      table.remove(game.player.bullets)
    else
      bullet:update(requests)
      i = i + 1
    end
  end
end

return game
