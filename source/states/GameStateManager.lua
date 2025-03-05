--[[
    Game State Management Module
    This module handles switching between different game states dynamically.
    There shouldn't be much to write here but the different game states lambda wraps.

    Features:
    - Supports switching between different game states.
    - Calls appropriate lifecycle methods (`enter`, `leave`, `update`, `draw`).
    - Passes input events to the active game state.
--]]

local GameStateManager = {}
local currentGameState = nil

--[[
    Switches to a new game state.
    @param newState (table) - The new state module to switch to.
--]]
function GameStateManager:switch(newState)
   if newState then
        -- Call leave function of the current state (if exists)
        if self.currentGameState and self.currentGameState.leave then
            self.currentGameState:leave()
        end
        
        -- Set the new state
        self.currentGameState = newState
        
        -- Call enter function of the new state (if exists)
        if self.currentGameState.enter then
            self.currentGameState:enter()
        end
   else
        -- Debugging message in case of invalid state switch
        print("[ERROR-GAMESTATE] Attempted to switch to nil state")
   end
end

--[[ 
    Switches to the Intro game state.
--]]
function GameStateManager:enableIntro()
    self:switch(require('source.states.running'))
end

--[[ 
    Switches to the Menu game state.
--]]
function GameStateManager:enableMenu()
    self:switch(require('source.states.menu'))
end

--[[ 
    Calls the update function of the current game state.
    @param dt (number) - Delta time since last frame.
--]]
function GameStateManager:update(dt)
    if self.currentGameState and self.currentGameState.update then
        self.currentGameState:update(dt)
    end
end

--[[ 
    Calls the draw function of the current game state.
--]]
function GameStateManager:draw()
    if self.currentGameState and self.currentGameState.draw then
        self.currentGameState:draw()
    end
end

--[[ 
    Passes mouse press events to the current game state.
    @param x (number) - Mouse X position.
    @param y (number) - Mouse Y position.
    @param button (number) - Mouse button pressed.
--]]
function GameStateManager:mousepressed(x, y, button)
    if self.currentGameState and self.currentGameState.mousepressed then
        self.currentGameState:mousepressed(x, y, button)
    end
end

--[[ 
    Passes text input events to the current game state.
    @param key (string) - The input key as a string.
--]]
function GameStateManager:textinput(key)
    if self.currentGameState and self.currentGameState.textinput then
        self.currentGameState:textinput(key)
    end
end

--[[ 
    Passes key press events to the current game state.
    @param key (string) - The key pressed.
--]]
function GameStateManager:keypressed(key)
    if self.currentGameState and self.currentGameState.keypressed then
        self.currentGameState:keypressed(key)
    end
end

--[[ 
    Passes key release events to the current game state.
    @param key (string) - The key released.
--]]
function GameStateManager:keyreleased(key)
    if self.currentGameState and self.currentGameState.keyreleased then
        self.currentGameState:keyreleased()
    end
end

return GameStateManager