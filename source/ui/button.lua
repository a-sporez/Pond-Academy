--[[
    Button Module
    This module defines a simple button system for Love2D. 
    It creates buttons with dynamic dimensions and colors, 
    allowing interaction via mouse clicks.

    Features:
    - Draws a button.
    - Handles mouse click detection.
    - Executes a function when clicked.
--]]

local button = {}
button.__index = button

--[[
    Creates a new button instance.
    @param x (number) - X position of the button.
    @param y (number) - Y position of the button.
    @param width (number) - Button width.
    @param height (number) - Button height.
    @param text (string) - Text displayed on the button.
    @param func (function) - Function executed on click.
    @param func_param (any) - Optional parameter for the function.
    @return (table) - New button instance.
--]]
function button.new(x, y, width, height, text, func, func_param)
    local self = setmetatable({}, button)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text or "<none>"
    self.func = func or function() print("No function assigned") end
    self.func_param = func_param
    return self
end

--[[
    Checks if the button is pressed.
    @param mouse_x (number) - X position of the mouse.
    @param mouse_y (number) - Y position of the mouse.
    @param cursor_radius (number) - Radius around the cursor for detection.
--]]
function button:checkPressed(mouse_x, mouse_y, cursor_radius)
    if (mouse_x + cursor_radius >= self.x and
        mouse_x - cursor_radius <= self.x + self.width) and
        (mouse_y + cursor_radius >= self.y and
        mouse_y - cursor_radius <= self.y + self.height) then
        if self.func_param then
            self.func(self.func_param)
        else
            self.func()
        end
    end
end

--[[
    Draws the button on screen with a stylized background.
--]]
function button:draw()
    -- Draw button background
    love.graphics.setColor(1, 0.4, 0.4) -- Pink
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 5, 5)
    
    -- Draw text background
    love.graphics.setColor(1, 0.8, 0.8) -- Light pastel pink
    love.graphics.rectangle("fill", self.x + 5, self.y + 5, self.width - 10, self.height - 10, 5, 5)
    
    -- Draw text
    love.graphics.setColor(0, 0, 0) -- Black text
    love.graphics.printf(self.text, self.x, self.y + (self.height / 2) - 6, self.width, "center")
    
    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

return button