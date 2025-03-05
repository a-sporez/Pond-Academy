--[[
    Running State Module
    This state serves as the entry point for the game.
    It transitions directly into the Archives scene.
--]]

local Archives = require "source.scenes.archives"  -- Include the Archives scene
local Library  = require "source.scenes.library"

local Running = {}

local DRAW_SCALE = 1 -- global drawing scale on the canvas.

--[[
    Called when the Running state is entered.
    Initializes the Archives scene immediately.
--]]
function Running:enter()
    self.scenes = {
        archives = Archives:new(),
        library = Library:new()
    }
    self.current_scene = 'archives'

    self.canvas = love.graphics.newCanvas(
        love.graphics.getWidth() / DRAW_SCALE,
        love.graphics.getHeight() / DRAW_SCALE
    )
end

--[[
    Switches between scenes within this state
    @param scene_name (string) - The name of thescene to switch to
--]]
function Running:switchScene(scene_name)
    if self.scenes[scene_name] then
        print("[DEBUG-Running] Switching to scene:", scene_name)
        self.current_scene = scene_name

        -- Recreate the scene with the origin info (optional for now)
        if scene_name == "archives" then
            self.scenes[scene_name] = Archives:new('library')  -- Indicate player is coming from library
        elseif scene_name == "library" then
            self.scenes[scene_name] = Library:new('archives')
        end
    else
        print("[ERROR-Running] Scene not found:", scene_name)
    end
end

--[[
    Updates the current scene.
    @param dt (number) - Delta time since last frame.
--]]
function Running:update(dt)
    if self.scenes[self.current_scene] then
        self.scenes[self.current_scene]:update(dt)

        -- Generalized scene transition check
        local next_scene = self.scenes[self.current_scene]:checkForSceneSwitch()
        if next_scene then
            self:switchScene(next_scene)
        end
    end
end

--[[
    Draws the current scene.
--]]
function Running:draw()
    -- set the canvas as rendering target
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    if self.scenes[self.current_scene] then
        self.scenes[self.current_scene]:draw()
    end
    -- reset canvas to default
    love.graphics.setCanvas()

    love.graphics.push()
    love.graphics.scale(DRAW_SCALE, DRAW_SCALE)
    love.graphics.draw(self.canvas, 0, 0)
    love.graphics.pop()

    -- draw elements on top of the canvas
    local scene = self.scenes[self.current_scene]
    if scene and scene:getDialogue() then
        scene:getDialogue():draw()
    end
end

--[[
    Handles keyboard input and passes it to the current scene.
    @param key (string) - The key pressed.
--]]
function Running:keypressed(key)
    if self.scenes[self.current_scene] then
        self.scenes[self.current_scene]:keypressed(key)
    end
end

--[[
    Handles mouse input and passes it to the current scene.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param button (number) - Mouse button pressed.
--]]
function Running:mousepressed(x, y, button)
    if self.scenes[self.current_scene] and self.scenes[self.current_scene].mousepressed then
        self.scenes[self.current_scene]:mousepressed(x, y, button)
    end
end

return Running