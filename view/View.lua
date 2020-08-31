local view = {}

cell_size = 40
upper_x = 50
upper_y = 50

function view.draw(game)
  drawInfo(game)
  drawBoard(game)
  drawPlayer(game)
  drawAliens(game)
  drawBullets(game.player.bullets)
  drawBullets(game.aliens_fleet.bullets)
end

function drawInfo(game)
  -- info
  --love.graphics.setColor(0, 1, 0)
  love.graphics.print(game.player.position.x, 10, 10)
  love.graphics.print(game.player.position.y, 40, 10)
  love.graphics.print(game.aliens_fleet.no_left_move and 'true' or 'false', 70, 10)
  love.graphics.print(game.aliens_fleet.no_right_move and 'true' or 'false', 110, 10)
end

function drawBoard(game)
  -- board
  width = game.board_cols * cell_size
  height = game.board_rows * cell_size
  love.graphics.rectangle("line", upper_x, upper_y, width, height)
  for i = 0, game.board_rows - 1 , 1
  do
    for j = 0, game.board_cols - 1, 1
    do
      x = upper_x + (j * cell_size)
      y = upper_y + (i * cell_size)
      love.graphics.rectangle("line", x, y, cell_size, cell_size)
    end
  end
end

function drawPlayer(game)
  -- players
  x = upper_x + (game.player.position.x * cell_size)
  y = upper_y + (game.player.position.y * cell_size)
  love.graphics.rectangle("fill", x, y, cell_size, cell_size)
end

function drawAliens(game)
  for i = 1, table.getn(game.aliens_fleet.aliens), 1
    do
      for j = 1, table.getn(game.aliens_fleet.aliens[i]), 1
      do
        alien = game.aliens_fleet.aliens[i][j]
        if not alien.isDirty then
          x = upper_x + (alien.position.x * cell_size) + cell_size/2
          y = upper_y + (alien.position.y * cell_size) + cell_size/2
          love.graphics.circle("fill", x, y, cell_size/2 - 5)
        end
      end
    end
end

function drawBullets(bullets_table)
  for i = 1, table.getn(bullets_table), 1
  do
    x = upper_x + (bullets_table[i].position.x * cell_size) + (cell_size/2)
    y1 = upper_y + (bullets_table[i].position.y * cell_size)
    y2 = y1 - cell_size/2
    if bullets_table[i].direction == "down" then
      y2 = y1 + cell_size/2
    end
    love.graphics.line(x,y1, x,y2)
  end
end

return view
