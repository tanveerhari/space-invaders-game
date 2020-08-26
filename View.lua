local view = {}

cell_size = 50
upper_x = 50
upper_y = 50

function view.draw(game)
  drawInfo(game)
  drawBoard(game)
  drawPlayer(game)
end

function drawInfo(game)
  -- info
  --love.graphics.setColor(0, 1, 0)
  love.graphics.print(game.k, 10, 10)
end

function drawBoard(game)
  -- board
  width = game.board_cols * cell_size
  height = game.board_rows * cell_size
  love.graphics.rectangle("line", upper_x, upper_y, width, height)
end

function drawPlayer(game)
  -- players
  x = upper_x + (game.player_x * cell_size)
  y = upper_y + (game.player_y * cell_size)
  love.graphics.rectangle("fill", x, y, cell_size, cell_size)

end

return view
