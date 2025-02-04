local button = require "source.ui.button"
local state  = require "source.states.state"


local Menu = {}
local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()
local centre_x = window_width / 2
local centre_y = window_height / 2
local offset_x, offset_y = 48, 18

function Menu:enter()
    -- load font for the menu state and store it
    local menu_font = love.graphics.newFont('assets/fonts/setbackt.ttf')
    -- initialize font after storing it
    love.graphics.setFont(menu_font)

    -- Construct buttons below (x, y, width, height, text, func, func_param)
    self.playButton = button.new(
        centre_x - offset_x,
        centre_y - offset_y,
        96,
        36,
        "PLAY",
        function () state:enableRunning() end, -- lambda wrap game state.
        nil
    )
end

function Menu:update(dt)
    
end

function Menu:draw()
    -- TODO: remove semi-hardcoded values below
    love.graphics.print("menu state", 10, 10)
    self.playButton:draw(self.button_x, self.button_y, 14, 7)
end

function Menu:mousepressed(x, y, button)
    if button == 1 and self.playButton then
        self.playButton:checkPressed(x, y, button)
        print("[DEBUG-MENU] playButton pressed")
    end
end

return Menu