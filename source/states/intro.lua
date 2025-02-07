local Dialogue = require "source.dialogues.dialogue"

--[[
    Intro State Module
    This state serves as the entry point for the game.
    It initializes a dialogue system for interaction.
--]]
local Intro = {}

--[[
    Called when the Intro state is entered.
    Initializes the dialogue system.
--]]
function Intro:enter()
    self.dialogue = Dialogue:new() -- Create a new dialogue instance
end

--[[
    Updates the Intro state (if necessary).
    @param dt (number) - Delta time since last frame.
--]]
function Intro:update(dt)
    -- No update logic needed for now
end

--[[
    Draws the Intro state elements, including the dialogue UI.
--]]
function Intro:draw()
    love.graphics.print("Intro state", 10, 10)
    if self.dialogue then
        self.dialogue:draw()
    end
end

--[[
    Handles keyboard input and passes it to the dialogue system.
    @param key (string) - The key pressed.
--]]
function Intro:keypressed(key)
    if self.dialogue then
        self.dialogue:keypressed(key)
    end
end

--[[
    Handles mouse input and passes it to the dialogue system.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param button (number) - Mouse button pressed.
--]]
function Intro:mousepressed(x, y, button)
    if self.dialogue then
        self.dialogue:mousepressed(x, y, button)
    end
end

return Intro