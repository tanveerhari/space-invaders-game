local view = {}

cell_size = 40
upper_x = 50
upper_y = 50

function view.draw(game)
  drawInfo(game)
  drawBoard(game)
  drawPlayer(game)
  drawAliens(game)
  --drawBullets(game.player.bullets)
  --drawBullets(game.aliens_fleet.bullets)
end

function getViewPoint(board_point)
  return {
    x = upper_x + ((board_point.x - 1) * cell_size),
    y = upper_y + ((board_point.y - 1) * cell_size)
  }
end

function drawInfo(game)
  -- info
  --love.graphics.setColor(0, 1, 0)
  love.graphics.print("score:", 10, 10)
  love.graphics.print(game.score, 50, 10)
  love.graphics.print("lives:", 100, 10)
  love.graphics.print(game.player.lives, 140, 10)
  love.graphics.print(game.is_in_play and "true" or "false", 180, 10)
  love.graphics.print(game.aliens_fleet.down_level, 210, 10)
end

function drawBoard(game)
  -- board
  width = game.board.cols * cell_size
  height = game.board.rows * cell_size
  love.graphics.rectangle("line", upper_x, upper_y, width, height)
  -- for i = 1, game.board.rows, 1
  -- do
  --   for j = 1, game.board.cols, 1
  --   do
  --     view_point = getViewPoint({x = j, y = i})
  --     --x = upper_x + (j * cell_size)
  --     --y = upper_y + (i * cell_size)
  --     love.graphics.rectangle("line", view_point.x, view_point.y, cell_size, cell_size)
  --   end
  -- end
end

function drawPlayer(game)
  -- player
  --x = upper_x + (game.player.position.x * cell_size)
  --y = upper_y + (game.player.position.y * cell_size)
  view_point = getViewPoint(game.player.position)
  love.graphics.rectangle("fill", view_point.x, view_point.y, cell_size, cell_size)
  drawBullets(game.player.bullets)
end

function drawAliens(game)
  for i = 1, table.getn(game.aliens_fleet.aliens), 1
    do
      for j = 1, table.getn(game.aliens_fleet.aliens[i]), 1
      do
        alien = game.aliens_fleet.aliens[i][j]
        if not alien.is_dirty then
          view_point = getViewPoint(alien.position)
          x = view_point.x + cell_size/2
          y = view_point.y + cell_size/2
          love.graphics.circle("fill", x, y, cell_size/2 - 5)
        end
        drawBullets(alien.bullets)
      end
    end
end

function drawBullets(bullets_table)
  for i = 1, table.getn(bullets_table), 1
  do
    view_point = getViewPoint(bullets_table[i].position)
    x = view_point.x + (cell_size/2)
    y1 = view_point.y
    y2 = y1 - cell_size/2
    if bullets_table[i].direction == "down" then
      y2 = y1 + cell_size/2
    end
    love.graphics.line(x, y1, x, y2)
  end
end

return view
