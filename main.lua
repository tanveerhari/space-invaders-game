function love.load()
  game = require("game/game")
  view = require("view/view")

end

function love.update(dt)
  game.update()
end

function love.draw()
  view.draw(game)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "left" then
    game.player.state = "move_left"
  elseif key == "right" then
    game.player.state = "move_right"
  elseif key == "lctrl" then
    game.player.state = "shoot"
  end
end

function love.conf(t)
	t.console = true
end
