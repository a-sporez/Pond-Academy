local State = {}
local currentState = nil

function State:switch(state)
   if state then
        -- check if the state has been triggered to leave
        if self.currentState and self.currentState.leave then
            self.currentState:leave()
        end
        -- sets the loaded state modules
        self.currentState = state
        -- check if the state is properly loaded then enters
        if self.currentState.enter then
            self.currentState:enter()
        end
   end
   -- print debug output if state is not properly loaded.
   if not state then
        print("[ERROR-STATE] Attempted to switch to nil state")
   end
end

-- lambda wrapper to set the running module as currentState
function State:enableIntro()
    self:switch(require('source.states.intro'))
end

-- lambda wrapper to set the menu module as currentState
function State:enableMenu()
    self:switch(require('source.states.menu'))
end

function State:update(dt)
    -- check for update callback in the currentState module.
    if self.currentState and self.currentState.update then
        self.currentState:update(dt)
    end
end

function State:draw()
    -- check for draw callback in the currentState module.
    if self.currentState and self.currentState.draw then
        self.currentState:draw()
    end
end

function State:mousepressed(x, y, press)
    -- check for draw callback in the currentState module.
    if self.currentState and self.currentState.mousepressed then
        self.currentState:mousepressed(x, y, press)
    end
end

function State:textinput(key)
    -- check for textinput callback in the currentState module.
    if self.currentState and self.currentState.textinput then
        self.currentState:textinput(key)
    end
end

function State:keypressed(key)
    -- check for keypressed callback in the currentState module.
    if self.currentState and self.currentState.keypressed then
        self.currentState:keypressed(key)
    end
end

function State:keyreleased(key)
    -- check for keyreleased callback in the currentState module.
    if self.currentState and self.currentState.keyreleased then
        self.currentState:keyreleased()
    end
end

return State