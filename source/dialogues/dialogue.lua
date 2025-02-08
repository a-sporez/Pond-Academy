--[[
    Dialogue Module
    This module defines a simple dialogue system for Love2D.
    It initializes the entry point for dialogue but loads each dialogue node
    (e.g., Critter conversations) from separate files.

    Features:
    - Supports multiple dialogue nodes with branching options.
    - Loads dialogue nodes dynamically from separate modules.
    - Handles keyboard and mouse inputs to navigate dialogue.
--]]

local button = require "source.ui.button"
local Dialogue = {}
Dialogue.__index = Dialogue

-- Load dialogue nodes from separate files
local critter_1 = require "source.dialogues.nodes.critter_1"
local critter_2 = require "source.dialogues.nodes.critter_2"
local critter_3 = require "source.dialogues.nodes.critter_3"
local critter_4 = require "source.dialogues.nodes.critter_4"

-- Get window dimensions
local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

-- Button dimensions
local button_width = 200
local button_height = 40

--[[
    Creates a new Dialogue instance.
    Initializes the dialogue tree and creates buttons dynamically.
    @return (table) - New Dialogue instance.
--]]
function Dialogue:new()
    local instance = setmetatable({}, Dialogue)
    -- Define the entry point of the dialogue tree
    instance.dialogue_tree = {
        archives = {
            text = "Archives Entry Placeholder",
            options = {
                {text = "Enter Node 1", next = 'critter_1'},
                {text = "Enter Node 2", next = 'critter_2'},
                {text = "Enter Node 3", next = 'critter_3'},
                {text = "Enter Node 4", next = 'critter_4'}
            }
        }
    }
    
    -- Merge loaded critter dialogues into the main dialogue tree
    instance.dialogue_tree.critter_1 = critter_1
    instance.dialogue_tree.critter_2 = critter_2
    instance.dialogue_tree.critter_3 = critter_3
    instance.dialogue_tree.critter_4 = critter_4
    
    instance.current_node = 'archives'
    instance.buttons = {}
    instance:createButtons()
    return instance
end

--[[
    Creates buttons dynamically based on the current dialogue node options.
--]]
function Dialogue:createButtons()
    self.buttons = {}
    local node = self.dialogue_tree[self.current_node]
    local button_x = (window_width - button_width) / 2 -- Center buttons horizontally
    local button_y = (window_height / 2) - ((#node.options * button_height) / 2) -- Center vertically

    for i, option in ipairs(node.options) do
        table.insert(self.buttons, button.new(
            button_x, 
            button_y + (i - 1) * (button_height + 10), -- Space evenly
            button_width, 
            button_height, 
            option.text,
            function() self:setNode(option.next) end,
            nil
        ))
    end
end

--[[
    Changes the current dialogue node and updates available buttons.
    @param node_id (string) - The ID of the new dialogue node.
--]]
function Dialogue:setNode(node_id)
    if self.dialogue_tree[node_id] then
        self.current_node = node_id
        self:createButtons()
    else
        print("[ERROR-Dialogue] dialogue node not found.")
    end
end

--[[
    Draws the current dialogue text and buttons on screen.
--]]
function Dialogue:draw()
    local node = self.dialogue_tree[self.current_node]
    love.graphics.printf(node.text, 10, 20, window_width - 20, "center") -- Center text
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

--[[
    Handles keyboard input to navigate dialogue.
    @param key (string) - The key pressed by the player.
--]]
function Dialogue:keypressed(key)
    local node = self.dialogue_tree[self.current_node]
    if key >= '1' and key <= tostring(#node.options) then
        local choice_index = tonumber(key)
        self:setNode(node.options[choice_index].next)
    end
end

--[[
    Handles mouse input to navigate dialogue by clicking buttons.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param button (number) - Mouse button pressed.
--]]
function Dialogue:mousepressed(x, y, button)
    for _, btn in ipairs(self.buttons) do
        btn:checkPressed(x, y, 5)
    end
end

return Dialogue