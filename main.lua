local GameStateManager     = require('source.states.GameStateManager')
local Menu                 = require('source.states.menu')

function love.load()
    GameStateManager:switch(Menu)
end

function love.update(dt)
    GameStateManager:update(dt)
end

function love.draw()
    GameStateManager:draw()
end

function love.mousepressed(x, y, press)
    GameStateManager:mousepressed(x, y, press)
end

function love.textinput(key)
    GameStateManager:textinput(key)
end

function love.keypressed(key)
    GameStateManager:keypressed(key)
end

function love.keyreleased(key)
    GameStateManager:keyreleased(key)
end