local button = require "source.ui.button"

-- Load dialogue nodes dynamically
local critter_dialogues = {
    smug = require "source.dialogues.nodes.smug",
    olive = require "source.dialogues.nodes.olive",
    bambi = require "source.dialogues.nodes.bambi",
    wiz = require "source.dialogues.nodes.wiz"
}

local Dialogue = {}
Dialogue.__index = Dialogue

-- Window dimensions
local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

-- Button dimensions
local button_width = 200
local button_height = 40

--[[ 
    Creates a new Dialogue instance.
    @param critter_name (string) - The critter being interacted with.
    @return (table) - New Dialogue instance.
--]]
function Dialogue:new(critter_name)
    local instance = setmetatable({}, Dialogue)

    if not critter_dialogues[critter_name] then
        print("[ERROR] Dialogue file for critter '" .. tostring(critter_name) .. "' not found!")
        return nil
    end

    instance.critter_name = critter_name
    instance.dialogue_tree = critter_dialogues[critter_name]

    -- Log the loaded dialogue tree for debugging
    print("[DEBUG] Loaded dialogue for:", critter_name, "Nodes available:", instance.dialogue_tree)

    -- Ensure the root node exists before setting it
    if instance.dialogue_tree[critter_name] then
        instance.current_node = critter_name  -- Start at the critter's root
    else
        print("[ERROR] Root node '" .. critter_name .. "' not found in dialogue data! Using fallback 'node_1'.")
        instance.current_node = "node_1"  -- Fallback to node_1 if the critter root is missing
    end

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
        -- Handle exit condition
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

    -- Check if node exists inside the active critter's dialogue
    if self.dialogue_tree[node_id] then
        self.current_node = node_id
        self:createButtons()
    else
        print("[ERROR] Dialogue node '" .. tostring(node_id) .. "' not found for critter:", self.critter_name)
    end
end

--[[ 
    Draws the current dialogue text and buttons on screen.
--]]
function Dialogue:draw()
    if not self.current_node or not self.dialogue_tree[self.current_node] then
        print("[ERROR] Dialogue node '" .. tostring(self.current_node) .. "' not found for critter:", self.critter_name)
        return
    end

    local node = self.dialogue_tree[self.current_node]
    love.graphics.printf(node.text, 10, 20, window_width - 20, "center")

    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

function Dialogue:update(dt)
    if self.current_node then
        print("[DEBUG] Updating dialogue: " .. self.current_node)
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
