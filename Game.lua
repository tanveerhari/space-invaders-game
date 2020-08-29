local game = {}

game.board_x = 0
game.board_y = 0
game.board_rows = 12
game.board_cols = 15

mid_x = (game.board_cols - game.board_x)/2
game.player_x = math.floor(mid_x)
game.player_y = game.board_rows - 1

-- idle, shoot, move_left, move_right
game.player_state = "idle"

game.player_bullets = {}

game.points_map = {}

game.aliens = {}

game.aliens_direction = 0
alienDirectionTimer = 1
isAlienLeftMovePossible = true
isAlienRightMovePossible = true

game.alien_bullets = {}

function getNewAlien(alien_x, alien_y)
  return{
    x = alien_x,
    y = alien_y,
    isDirty = false
  }
end

for j = 1, math.floor(game.board_rows/4), 1
do
  for i = 1, game.board_cols - 2, 1
  do
    alien = getNewAlien(i, j)
    table.insert(game.aliens, alien)
    key = i..":"..j
    game.points_map[key] = alien
  end
end

function game.update()
  updatePlayer()
  updateAliens()
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

function updateAliens()
  removeDirtyAliens()
  updateAliensDirection()
  shootAlienBullets()
end

function shootAlienBullets()
  
end

function updateAliensDirection()
  if alienDirectionTimer == 50 then
    game.aliens_direction = math.random(0, 2)
    alienDirectionTimer = 1
    moveAliens()
  else
    alienDirectionTimer = alienDirectionTimer + 1
  end
end

function moveAliens()
  if game.aliens_direction == 1 then
    moveAliensLeft()
  elseif game.aliens_direction == 2 then
    moveAliensRight()
  end
end

function removeDirtyAliens()
  i = 1
  while i <= table.getn(game.aliens)
  do
    -- if alien is dirty then remove it
    if game.aliens[i].isDirty then
      game.aliens[i] = game.aliens[table.getn(game.aliens)]
      table.remove(game.aliens)
      --force repeat iteration
      i = i - 1
    end
    i = i + 1
  end
end

function moveAliensLeft()
  if isAlienLeftMovePossible then
    isAlienRightMovePossible = true
    for i = 1, table.getn(game.aliens), 1
    do
      old_key = game.aliens[i].x..":"..game.aliens[i].y
      game.aliens[i].x = game.aliens[i].x - 1
      new_key = game.aliens[i].x..":"..game.aliens[i].y
      game.points_map[old_key] = nil
      game.points_map[new_key] = game.aliens[i]
      if game.aliens[i].x == game.board_x then
        isAlienLeftMovePossible = false
      end
    end
  end
end

function moveAliensRight()
  if isAlienRightMovePossible then
    isAlienLeftMovePossible = true
    for i = table.getn(game.aliens), 1, -1
    do
      old_key = game.aliens[i].x..":"..game.aliens[i].y
      game.aliens[i].x = game.aliens[i].x + 1
      new_key = game.aliens[i].x..":"..game.aliens[i].y
      game.points_map[old_key] = nil
      game.points_map[new_key] = game.aliens[i]
      if game.aliens[i].x == game.board_cols - 1 then
        isAlienRightMovePossible = false
      end
    end
  end
end

function isAlienHit(bullet_x, bullet_y)
  key = bullet_x..":"..bullet_y
  occupant = game.points_map[key]
  if occupant == nil or occupant.isDirty then
    return false
  else
    occupant.isDirty = true
    return true
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
      if game.player_bullets[i].y - 0.5 <= 0 or isAlienHit(game.player_bullets[i].x, game.player_bullets[i].y - 0.5) then
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
