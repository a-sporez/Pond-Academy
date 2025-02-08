--[[
    Dialogue Module
    This module defines a simple dialogue system for Love2D.
    It allows players to navigate a structured dialogue tree 
    through button interactions or keyboard inputs.

    Features:
    - Supports multiple dialogue nodes with branching options.
    - Dynamically creates buttons for available dialogue choices.
    - Handles keyboard and mouse inputs to navigate dialogue.
--]]

local button = require "source.ui.button"
local Dialogue = {}
Dialogue.__index = Dialogue

-- Get window dimensions
local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()
local centre_x = window_width / 2
local centre_y = window_height / 2
local offset_x, offset_y = 48, 18

--[[
    Creates a new Dialogue instance.
    Initializes the dialogue tree and creates buttons dynamically.
    @return (table) - New Dialogue instance.
--]]
function Dialogue:new()
    local instance = setmetatable({}, Dialogue)
    -- Define the structure of the dialogue tree.
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
        critter_1 = {
            text = "Critter 1 Text",
            options = {
                {text = "Sub Node 1-1", next = 'critter_1_1'},
                {text = "Sub Node 1-2", next = 'critter_1_2'},
                {text = "Sub Node 1-3", next = 'critter_1_3'},
                {text = "Sub Node 1-4", next = 'critter_1_4'},
                {text = "Return to Archives", next = 'archives'}
            }
        },
        critter_2 = {
            text = "Critter 2 Text",
            options = {
                {text = "Sub Node 2-1", next = 'critter_2_1'},
                {text = "Sub Node 2-2", next = 'critter_2_2'},
                {text = "Sub Node 2-3", next = 'critter_2_3'},
                {text = "Sub Node 2-4", next = 'critter_2_4'},
                {text = "Return to Archives", next = 'archives'}
            }
        },
        critter_3 = {
            text = "Critter 3 Text",
            options = {
                {text = "Sub Node 3-1", next = 'critter_3_1'},
                {text = "Sub Node 3-2", next = 'critter_3_2'},
                {text = "Sub Node 3-3", next = 'critter_3_3'},
                {text = "Sub Node 3-4", next = 'critter_3_4'},
                {text = "Return to Archives", next = 'archives'}
            }
        },
        critter_4 = {
            text = "Critter 4 Text",
            options = {
                {text = "Sub Node 4-1", next = 'critter_4_1'},
                {text = "Sub Node 4-2", next = 'critter_4_2'},
                {text = "Sub Node 4-3", next = 'critter_4_3'},
                {text = "Sub Node 4-4", next = 'critter_4_4'},
                {text = "Return to Archives", next = 'archives'}
            }
        }
    }
    instance.current_node = 'archives'
    instance.buttons = {}
    instance:createButtons()
    return instance
end

--[[
    Creates buttons dynamically based on the current dialogue node options.
    TODO: remove hardcoded values
--]]
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
    love.graphics.printf(node.text, 10, 20, 400) -- Hardcoded text box
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