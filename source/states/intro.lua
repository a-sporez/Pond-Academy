--[[
    Intro State Module
    This state serves as the entry point for the game.
    It transitions directly into the Archives scene.
--]]

local Archives = require "source.scenes.archives"  -- Include the Archives scene

local Intro = {}

--[[
    Called when the Intro state is entered.
    Initializes the Archives scene immediately.
--]]
function Intro:enter()
    self.archives = Archives:new()  -- Load the Archives scene
end

--[[
    Updates the Archives scene.
    @param dt (number) - Delta time since last frame.
--]]
function Intro:update(dt)
    self.archives:update(dt)
end

--[[
    Draws the Archives scene.
--]]
function Intro:draw()
    self.archives:draw()
end

--[[
    Handles keyboard input and passes it to the Archives scene.
    @param key (string) - The key pressed.
--]]
function Intro:keypressed(key)
    self.archives:keypressed(key)
end

--[[
    Handles mouse input and passes it to the Archives scene.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param button (number) - Mouse button pressed.
--]]
function Intro:mousepressed(x, y, button)
    if self.archives.mousepressed then  -- Avoids error if not implemented
        self.archives:mousepressed(x, y, button)
    end
end

return Intro