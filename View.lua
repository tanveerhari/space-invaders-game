local view = {}

cell_size = 40
upper_x = 50
upper_y = 50

function view.draw(game)
  drawInfo(game)
  drawBoard(game)
  drawPlayer(game)
  drawBullets(game)
end

function drawInfo(game)
  -- info
  --love.graphics.setColor(0, 1, 0)
  love.graphics.print(game.player_x, 10, 10)
  love.graphics.print(game.player_y, 40, 10)
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
  x = upper_x + (game.player_x * cell_size)
  y = upper_y + (game.player_y * cell_size)
  love.graphics.rectangle("fill", x, y, cell_size, cell_size)
end

function drawBullets(game)
  for i = 1, player_bullet_count, 1
  do
    x = upper_x + (game.player_bullets[i].x * cell_size) + (cell_size/2)
    y1 = upper_y + (game.player_bullets[i].y * cell_size)
    y2 = y1 - cell_size/2
    love.graphics.line(x,y1, x,y2)
  end
end

return view
