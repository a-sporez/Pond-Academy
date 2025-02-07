--[[
    State Management Module
    This module handles the game states and allows switching 
    between different states dynamically.

    Features:
    - Supports switching between different game states.
    - Calls appropriate lifecycle methods (`enter`, `leave`, `update`, `draw`).
    - Passes input events to the active state.
--]]

local State = {}
local currentState = nil

--[[
    Switches to a new game state.
    @param state (table) - The new state module to switch to.
--]]
function State:switch(state)
   if state then
        -- Check if a state is currently active and call its leave function (if exists)
        if self.currentState and self.currentState.leave then
            self.currentState:leave()
        end
        
        -- Set the new state
        self.currentState = state
        
        -- Call the enter function of the new state (if exists)
        if self.currentState.enter then
            self.currentState:enter()
        end
   else
        -- Debugging message in case of invalid state switch
        print("[ERROR-STATE] Attempted to switch to nil state")
   end
end

--[[
    Switches to the Intro state.
--]]
function State:enableIntro()
    self:switch(require('source.states.intro'))
end

--[[
    Switches to the Menu state.
--]]
function State:enableMenu()
    self:switch(require('source.states.menu'))
end

--[[
    Calls the update function of the current state.
    @param dt (number) - Delta time since last frame.
--]]
function State:update(dt)
    if self.currentState and self.currentState.update then
        self.currentState:update(dt)
    end
end

--[[
    Calls the draw function of the current state.
--]]
function State:draw()
    if self.currentState and self.currentState.draw then
        self.currentState:draw()
    end
end

--[[
    Passes mouse press events to the current state.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param press (number) - Mouse button pressed.
--]]
function State:mousepressed(x, y, press)
    if self.currentState and self.currentState.mousepressed then
        self.currentState:mousepressed(x, y, press)
    end
end

--[[
    Passes text input events to the current state.
    @param key (string) - The input key as a string.
--]]
function State:textinput(key)
    if self.currentState and self.currentState.textinput then
        self.currentState:textinput(key)
    end
end

--[[
    Passes key press events to the current state.
    @param key (string) - The key pressed.
--]]
function State:keypressed(key)
    if self.currentState and self.currentState.keypressed then
        self.currentState:keypressed(key)
    end
end

--[[
    Passes key release events to the current state.
    @param key (string) - The key released.
--]]
function State:keyreleased(key)
    if self.currentState and self.currentState.keyreleased then
        self.currentState:keyreleased()
    end
end

return State