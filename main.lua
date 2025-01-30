local State     = require('source.states.state')
local Menu      = require('source.states.menu')

function love.load()
    State:switch(Menu)
end

function love.update(dt)
    State:update(dt)
end

function love.draw()
    State:draw()
end

function love.mousepressed(x, y, press)
    State:mousepressed(x, y, press)
end

function love.textinput(key)
    State:textinput(key)
end

function love.keypressed(key)
    State:keypressed(key)
end

function love.keyreleased(key)
    State:keyreleased(key)
end