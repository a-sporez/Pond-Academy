--[[
    Running State Module
    This state serves as the entry point for the game.
    It transitions directly into the Archives scene.
--]]

local SceneManager = require 'source.scenes.SceneManager'

local Running = {}

function Running:enter()
    SceneManager:switch('archives')
end

--[[
    Updates the current scene.
    @param dt (number) - Delta time since last frame.
--]]
function Running:update(dt)
    SceneManager:update(dt)
end

function Running:draw()
    SceneManager:draw()
end

--[[
    Handles keyboard input and passes it to the current scene.
    @param key (string) - The key pressed.
--]]
function Running:keypressed(key)
    local scene = SceneManager.current_scene

    if key == "escape" then
        if scene and scene.inDialogue then
            -- Let the scene handle Escape (e.g., closing dialogue)
            scene:keypressed(key)
            return
        else
            -- Exit to menu if no dialogue is active
            print("[DEBUG-Running] Returning to menu from Running state.")
            require("source.states.GameStateManager"):enableMenu()
        end
        return
    end
    SceneManager:keypressed(key)
end

--[[
    Handles mouse input and passes it to the current scene.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param button (number) - Mouse button pressed.
--]]
function Running:mousepressed(x, y, button)
    SceneManager:mousepressed(x, y, button)
end

return Running