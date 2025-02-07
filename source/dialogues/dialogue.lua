local button = require "source.ui.button"
local Dialogue = {}
Dialogue.__index = Dialogue

local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()
local centre_x = window_width / 2
local centre_y = window_height / 2
local offset_x, offset_y = 48, 18

function Dialogue:new()
    local instance = setmetatable({}, Dialogue)
    -- hardcoded dialogue tree to use as example without being too messy.
    instance.dialogue_tree = {
        archives = {
            text = "Archives Entry Placeholder",
            options = {
                {text = "Enter Node 1", next = 'critter_1'},
                {text = "Enter Node 2", next = 'critter_2'},
                {text = "Enter Node 3", next = 'critter_3'},
                {text = "Enter Node 4", next = 'critter_4'}
            }
        },
        critter_1 = {text = "Critter 1 Text", options = {{text = "Return to Archives", next = 'archives'}}},
        critter_2 = {text = "Critter 2 Text", options = {{text = "Return to Archives", next = 'archives'}}},
        critter_3 = {text = "Critter 3 Text", options = {{text = "Return to Archives", next = 'archives'}}},
        critter_4 = {text = "Critter 4 Text", options = {{text = "Return to Archives", next = 'archives'}}},
    }
    instance.current_node = 'archives'
    instance.buttons = {}
    instance:createButtons()
    return instance
end

function Dialogue:createButtons()
    self.buttons = {}
    local node = self.dialogue_tree[self.current_node]
    for i, option in ipairs(node.options) do
        table.insert(self.buttons, button.new(
            50, 100 + (i * 30), 150, 30, option.text,
            function() self:setNode(option.next) end,
            nil
        ))
    end
end

function Dialogue:setNode(node_id)
    if self.dialogue_tree[node_id] then
        self.current_node = node_id
        self:createButtons()
    else
        print("[ERROR-Dialogue] dialogue node not found.")
    end
end

function Dialogue:draw()
    local node = self.dialogue_tree[self.current_node]
    love.graphics.printf(node.text, 10, 20, 400) -- hardcoded text box
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

function Dialogue:keypressed(key)
    local node = self.dialogue_tree[self.current_node]
    -- register integer key input and assign node id for response.
    if key >= '1' and key <= tostring(#node.options) then
        local choice_index = tonumber(key)
        self:setNode(node.options[choice_index].next)
    end
end

function Dialogue:mousepressed(x, y, button)
    for _, btn in ipairs(self.buttons) do
        btn:checkPressed(x, y, 5)
    end
end

return Dialogue