--[[
    Running State Module
    This state serves as the entry point for the game.
    It transitions directly into the Archives scene.
--]]

local Archives = require "source.scenes.archives"  -- Include the Archives scene
local Library  = require "source.scenes.library"

local Running = {}

--[[
    Called when the Running state is entered.
    Initializes the Archives scene immediately.
--]]
function Running:enter()
    -- nil
end

function Running:initializeScenes()
    if not self.scenes then
        self.scenes = {
            archives = require("source.scenes.archives"):new(),
            library = require("source.scenes.library"):new()
        }
        self.current_scene = 'archives'
    end
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
    if self.scenes[self.current_scene] then
        self.scenes[self.current_scene]:draw()
    end
end

--[[
    Handles keyboard input and passes it to the current scene.
    @param key (string) - The key pressed.
--]]
function Running:keypressed(key)
    local scene = self.scenes[self.current_scene]

    if key == "escape" then
        if scene and scene.inDialogue then
            -- Let the scene handle Escape (e.g., closing dialogue)
            scene:keypressed(key)
            return
        else
            -- Exit to menu only if no dialogue is active
            print("[DEBUG-Running] Returning to menu from Running state.")
            require("source.states.GameStateManager"):enableMenu()
            return
        end
    end

    if scene then
        scene:keypressed(key)
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