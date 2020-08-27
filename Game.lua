local game = {}

game.board_x = 0
game.board_y = 0
game.board_rows = 10
game.board_cols = 15

mid_x = (game.board_cols - game.board_x)/2
game.player_x = math.floor(mid_x)
game.player_y = game.board_rows - 1

-- idle, shoot, move_left, move_right
game.player_state = "idle"

game.player_bullets = {}
--player_bullet_count = 0

function game.update()
  updatePlayer()
  updatePlayerBullets()
end

function updatePlayer()
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
  --for i = 1, table.getn(game.player_bullets), 1
  i = 1
  while i <= table.getn(game.player_bullets)
  do
    -- is move to be updated
    if game.player_bullets[i].t == 5 then
      -- is collision
      if game.player_bullets[i].y - 0.5 <= 0 then
        game.player_bullets[i] = game.player_bullets[table.getn(game.player_bullets)]
        table.remove(game.player_bullets)
        --force repeat iteration
        i = i - 1
      else --update move
        game.player_bullets[i].y = game.player_bullets[i].y - 0.5
        game.player_bullets[i].t = 0
      end
    else
      game.player_bullets[i].t = game.player_bullets[i].t + 1
    end
    i = i + 1
  end
end

function movePlayer(direction)
  if direction == "left" and game.player_x > game.board_x then
    game.player_x = game.player_x - 1
  elseif direction == "right" and game.player_x < game.board_cols - 1 then
    game.player_x = game.player_x + 1
  end
end

function shootPlayerBullet()
  --player_bullet_count = player_bullet_count + 1
  --game.player_bullets[player_bullet_count] = getNewBullet(game.player_x, game.player_y)
  table.insert(game.player_bullets, getNewBullet(game.player_x, game.player_y))
end

function getNewBullet(shooter_x, shooter_y)
  return {
    x = shooter_x,
    y = shooter_y,
    t = 0
  }
end

return game
