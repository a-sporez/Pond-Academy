local button = require 'source.ui.button'
local state  = require 'source.states.GameStateManager'

local Menu = {}
local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()
local centre_x = window_width / 2
local centre_y = window_height / 2
local offset_x, offset_y = 48, 18

--[[
    Initializes the menu state.
    Loads font and creates the play & exit buttons.
--]]
function Menu:enter()
    -- Load and store menu font
    self.menu_font = love.graphics.newFont('assets/fonts/CyberphontA.ttf', 24)
    love.graphics.setFont(self.menu_font)

    -- Create buttons for menu
    self.playButton = button.new(
        centre_x - offset_x,
        centre_y - offset_y,
        96,
        36,
        "PLAY",
        function () state:enableIntro() end, -- Switch to intro state
        nil
    )

    self.exitButton = button.new(
        centre_x - offset_x,
        centre_y + offset_y,
        96,
        36,
        "EXIT",
        love.event.quit,
        nil
    )
end

--[[
    Updates the menu state (currently unused).
    @param dt (number) - Delta time since last frame.
--]]
function Menu:update(dt)
    -- No update logic needed for static menu
end

--[[
    Draws the menu state elements.
--]]
function Menu:draw()
    love.graphics.print("Menu State", 10, 10)

    -- Draw buttons at their positions
    self.playButton:draw()
    self.exitButton:draw()
end

--[[
    Handles mouse input for button interaction.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param button (number) - Mouse button pressed.
--]]
function Menu:mousepressed(x, y, button)
    if button == 1 then -- Left mouse button
        if self.playButton then
            self.playButton:checkPressed(x, y, button)
            print("[DEBUG-MENU] playButton pressed")
        end
        if self.exitButton then
            self.exitButton:checkPressed(x, y, button)
            print("[DEBUG-MENU] exitButton pressed")
        end
    end
end

return Menu