local game = {}

game.board_x = 0
game.board_y = 0
game.board_rows = 10
game.board_cols = 10

game.player_x = (game.board_rows - game.board_x)/2
game.player_y = game.board_cols - 2

-- idle, shoot, move_left, move_right
game.player_state = "idle"

game.player_bullets = {}
player_bullet_count = 0

game.k = ""

function game.update()
  updatePlayerBullets()
  if game.player_state == "move_left" then
    movePlayer("left")
    game.player_state = "idle"
  elseif game.player_state == "move_right" then
    movePlayer("right")
    game.player_state = "idle"
  elseif game.player_state == "shoot" then
    shootPlayerBullet()
    game.player_state = "idle"
  end
end

function updatePlayerBullets()
  
end

function movePlayer(direction)
  if direction == "left" and game.player_x > game.board_x then
    game.player_x = game.player_x - 1
  elseif direction == "right" and game.player_x < game.board_cols - 1 then
    game.player_x = game.player_x + 1
  end
end

function shootPlayerBullet()
  player_bullet_count = player_bullet_count + 1
  game.player_bullets[player_bullet_count] = getNewBullet(game.player_x, game.player_y - 1)
end

function getNewBullet(shooter_x, shooter_y)
  return {
    x = shooter_x
    y = shooter_y
  }

end

return game
