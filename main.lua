function love.load()
  game = require("game")
  view = require("view")

end

function love.update(dt)
  game.update()
end

function love.draw()
  view.draw(game)
end

function love.keypressed(key, scancode, isrepeat)
  game.k = key
  if key == "left" then
    game.player_state = "move_left"
  elseif key == "right" then
    game.player_state = "move_right"
  elseif key == "lctrl" then
    game.player_state = "shoot"
  end
end
