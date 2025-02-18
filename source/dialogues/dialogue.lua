local button = require "source.ui.button"
local Dialogue = {}
Dialogue.__index = Dialogue

-- Load dialogue nodes dynamically
local critter_1 = require "source.dialogues.nodes.critter_1"
local critter_2 = require "source.dialogues.nodes.critter_2"
local critter_3 = require "source.dialogues.nodes.critter_3"
local critter_4 = require "source.dialogues.nodes.critter_4"

-- Window dimensions
local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

-- Button dimensions
local button_width = 200
local button_height = 40

--[[
    Creates a new Dialogue instance.
    @param start_node (string) - The entry point dialogue node.
    @return (table) - New Dialogue instance.
--]]
function Dialogue:new(start_node)
    local instance = setmetatable({}, Dialogue)

    -- Store dialogue tree
    instance.dialogue_tree = {
        critter_1 = critter_1,
        critter_2 = critter_2,
        critter_3 = critter_3,
        critter_4 = critter_4
    }

    -- Validate start_node
    if not instance.dialogue_tree[start_node] then
        print("[ERROR] Dialogue node '" .. tostring(start_node) .. "' not found!")
        return nil
    end

    instance.current_node = start_node
    instance.buttons = {}
    instance:createButtons()

    return instance
end

--[[
    Creates buttons dynamically based on the current dialogue node options.
--]]
function Dialogue:createButtons()
    self.buttons = {}

    -- Prevents issues if dialogue is closed
    if not self.current_node or not self.dialogue_tree[self.current_node] then
        return
    end

    local node = self.dialogue_tree[self.current_node]
    local button_x = (window_width - button_width) / 2
    local button_y = (window_height / 2) - ((#node.options * button_height) / 2)

    for i, option in ipairs(node.options) do
        -- Handle "Return to Archives" as a close action
        if option.text == "Return to Archives" then
            table.insert(self.buttons, button.new(
                button_x, 
                button_y + (i - 1) * (button_height + 10),
                button_width, 
                button_height, 
                "Close Dialogue",
                function()
                    print("[DEBUG] Closing dialogue...")
                    self.current_node = nil
                end,
                nil
            ))
        else
            table.insert(self.buttons, button.new(
                button_x, 
                button_y + (i - 1) * (button_height + 10),
                button_width, 
                button_height, 
                option.text,
                function() self:setNode(option.next) end,
                nil
            ))
        end
    end
end

--[[
    Changes the current dialogue node and updates available buttons.
    @param node_id (string) - The ID of the new dialogue node.
--]]
function Dialogue:setNode(node_id)
    if node_id == "archives" then
        print("[DEBUG] Closing dialogue and returning to Archives")
        self.current_node = nil
        return
    end

    -- First, check if the node exists in the main tree
    if self.dialogue_tree[node_id] then
        self.current_node = node_id
    else
        -- Check if it's a sub-node inside a critter's dialogue tree
        for _, critter in pairs(self.dialogue_tree) do
            if critter[node_id] then
                self.current_node = node_id
                -- Set active sub-node
                self.dialogue_tree[self.current_node] = critter[node_id]
                break
            end
        end
    end

    -- Ensure valid transition
    if not self.dialogue_tree[self.current_node] then
        print("[ERROR] Dialogue node '" .. tostring(node_id) .. "' not found!")
        return
    end

    self:createButtons()
end

--[[
    Draws the current dialogue text and buttons on screen.
--]]
function Dialogue:draw()
    local node = self.dialogue_tree[self.current_node]
    love.graphics.printf(node.text, 10, 20, window_width - 20, "center")
    
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

function Dialogue:update(dt)
    -- Placeholder: Add any update logic if needed
    print("[DEBUG] Updating dialogue: " .. self.current_node)
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
