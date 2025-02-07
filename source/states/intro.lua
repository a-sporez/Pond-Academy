local Dialogue = require "source.dialogues.dialogue"
-- TODO: Create entry point for dialogue tree.
local Intro = {}

function Intro:enter()
    self.dialogue = Dialogue:new()
end

function Intro:update(dt)
    
end

function Intro:draw()
    love.graphics.print("Intro state", 10, 10)
    self.dialogue:draw()
end

function Intro:keypressed(key)
    self.dialogue:keypressed(key)
end

function Intro:mousepressed(x, y, button)
    self.dialogue:mousepressed(x, y, button)
end

return Intro