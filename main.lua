function love.load()
  Game = require("game/Game")
  game = Game.new(12, 15)
  game:load(12,15)

  view = require("view/view")

end

function love.update(dt)
  game:update()
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
  elseif key == "n" and not game.is_in_play then
    love.load()
  end
end
