local game = {}

Player = require("game/Player")
AlienFleet = require("game/AlienFleet")
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

game.aliens_fleet = AlienFleet.newFleet(game.board_x + 1, game.board_y + 1, game.board_cols - 2, math.floor(game.board_rows/4))

function game.update()
  requests = BoardRequest.newRequestMap()
  game.player:update(requests)
  game.aliens_fleet:update(requests)
  updateBullets(game.player.bullets, requests)
  updateBullets(game.aliens_fleet.bullets, requests)
  updateBoard(requests)
end

function updateBoard(requests)
  for k in pairs(requests.map)
  do
    v = requests.map[k]
    if isPointWithinBoard(v.point) then
      v.occupant:move(v.point)
      -- check alien left-right move possibility here
      if v.occupant.type == "alien" then
        if v.occupant.position.x == game.board_x then
          game.aliens_fleet.no_left_move = true
        elseif v.occupant.position.x == game.board_cols - 1 then
          game.aliens_fleet.no_right_move = true
        end
      end
    elseif v.occupant.type == "bullet" then
      v.occupant.isDirty = true
    end
  end
end

function isPointWithinBoard(point)
  return point.x >= game.board_x and point.y >= game.board_y and  point.x < game.board_cols and point.y < game.board_rows
end

function updateBullets(bullets_table, requests)
  i = 1
  while i <= table.getn(bullets_table)
  do
    bullet = bullets_table[i]
    if bullet.isDirty then
      --remove bullet
      bullets_table[i] = bullets_table[table.getn(bullets_table)]
      table.remove(bullets_table)
    else
      bullet:update(requests)
      i = i + 1
    end
  end
end

return game
