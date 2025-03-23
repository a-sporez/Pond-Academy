local button = require "source.ui.button"

-- Load dialogue nodes dynamically.
local entity_dialogues = {
    smug  = require "source.dialogues.nodes.smug",
    olive = require "source.dialogues.nodes.olive",
    bambi = require "source.dialogues.nodes.bambi",
    wiz   = require "source.dialogues.nodes.wiz"
}

-- Assign large portrait sprites.
local entity_portraits = {
    smug  = love.graphics.newImage("assets/sprites/smug_large.png"),
    olive = love.graphics.newImage("assets/sprites/olive_large.png"),
    bambi = love.graphics.newImage("assets/sprites/bambi_large.png"),
    wiz   = love.graphics.newImage("assets/sprites/wiz_large.png")
}

-- conditional nodes
--[[
    node_COND1 = Represents acceptance that we are all trying to understand.
    (What are you not: everyone)
--]]

local Dialogue = {}
Dialogue.__index = Dialogue

-- Window dimensions
local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

--[[ 
    Creates a new Dialogue instance.
    @param entity_name (string) - The entity being interacted with.
    @return (table) - New Dialogue instance.
--]]
function Dialogue:new(entity_name, triggers)
    local instance = setmetatable({}, Dialogue)
    instance.triggers = triggers or {} -- conditional callbacks table

    if not entity_dialogues[entity_name] then
        print("[ERROR] Dialogue file for entity '" .. tostring(entity_name) .. "' not found!")
        return nil
    end

    instance.entity_name = entity_name
    instance.dialogue_tree = entity_dialogues[entity_name]
    instance.current_node = entity_name
    instance.large_sprite = entity_portraits[entity_name] or nil

    -- Create text canvas
    local canvas_width = window_width - 80
    local canvas_height = 100
    instance.text_canvas = love.graphics.newCanvas(canvas_width, canvas_height)

    instance.buttons = {}
    instance:createButtons()

    return instance
end

--[[ 
    Creates buttons dynamically based on the current dialogue node options.
--]]
function Dialogue:createButtons()
    self.buttons = {}

    if not self.current_node or not self.dialogue_tree[self.current_node] then
        return
    end

    local node = self.dialogue_tree[self.current_node]
    local button_x = window_width / 2
    local button_y = window_height / 2 + 50

    for i, option in ipairs(node.options) do
        local text_width = love.graphics.getFont():getWidth(option.text) + 20 -- Padding
        local text_height = love.graphics.getFont():getHeight() + 10

        table.insert(self.buttons, button.new(
            button_x - text_width / 2,
            button_y + (i - 1) * (text_height + 10),
            text_width,
            text_height,
            option.text,
            function() self:setNode(option.next) end
        ))
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

    -- Check if node exists inside the active entity's dialogue
    if self.dialogue_tree[node_id] then
        self.current_node = node_id
        self:createButtons()
    else
        print("[ERROR] Dialogue node '" .. tostring(node_id) .. "' not found for entity:", self.entity_name)
    end
    -- check if conditional node has been triggered.
    if node_id == "node_COND1" and self.triggers and self.triggers["node_COND1"] then
        self.triggers["node_COND1"]()
    end
end

--[[ 
    Draws the current dialogue text and buttons on screen.
--]]
function Dialogue:draw()
    if not self.current_node or not self.dialogue_tree[self.current_node] then
        print("[ERROR] Dialogue node '" .. tostring(self.current_node) .. "' not found for entity:", self.entity_name)
        return
    end

    local node = self.dialogue_tree[self.current_node]

    -- Draw large background portrait
    if self.large_sprite then
        love.graphics.setColor(1, 1, 1, 1) -- light transparency
        love.graphics.draw(self.large_sprite, 50, 60, 0, 2, 2) -- position and scale manually
        love.graphics.setColor(1, 1, 1, 1)
    end

    local font = love.graphics.getFont()
    local text_width, wrapped_text = font:getWrap(node.text, self.text_canvas:getWidth())
    local text_height = #wrapped_text * font:getHeight()

    local canvas_height = text_height + 60  -- Adjust canvas height based on text
    local text_y = (canvas_height - text_height) / 6

    local canvas_x = 40
    local canvas_y = 280

    -- Draw text onto the text canvas
    love.graphics.setCanvas(self.text_canvas)
    love.graphics.clear()
    love.graphics.printf(node.text, 0, text_y, self.text_canvas:getWidth(), 'center')
    love.graphics.setCanvas()

    -- Draw a subtle grey background behind the canvas (for visibility)
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle(
        "fill",
        canvas_x,
        canvas_y,
        self.text_canvas:getWidth(),
        self.text_canvas:getHeight(),
        20,
        20
    )

    -- Draw the text canvas
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.text_canvas, canvas_x, canvas_y)

    -- Draw buttons below the canvas
    local button_y_offset = canvas_y + canvas_height + 10
    for _, button in ipairs(self.buttons) do
        button.y = button_y_offset
        button:draw()
        button_y_offset = button_y_offset + button.height + 10
    end
end

function Dialogue:update(dt)
    print("[DEBUG] Updating dialogue:", self.current_node)
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
