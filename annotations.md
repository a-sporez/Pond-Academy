
## **💡 Project's annotations memory sheet**

### **📌 General Commenting Guidelines**
- **Module Header:** Provide a brief description of the module's purpose.
- **Function Headers:** Describe what the function does, its parameters, and return values.
- **Inline Comments:** Explain complex logic when necessary.

---

### **📝 1. Module Header**
Place at the **top of the file** to describe its purpose and key features.
```lua
--[[
    Module Name: Game State Manager
    Description: Manages different game states and transitions.
    
    Features:
    - Handles switching between game states.
    - Passes input and update calls to the current state.
    - Ensures lifecycle methods (`enter`, `leave`, `update`, `draw`) are properly managed.
--]]
```

---

### **🔹 2. Function Documentation**
Place **before a function** to explain its purpose, parameters, and return values.
```lua
--[[
    Switches the current game state.
    @param state (table) - The new state module to switch to.
--]]
function State:switch(state)
    if state then
        -- Call leave() on the previous state if applicable
        if self.currentState and self.currentState.leave then
            self.currentState:leave()
        end

        -- Switch to the new state and call enter() if applicable
        self.currentState = state
        if self.currentState.enter then
            self.currentState:enter()
        end
    else
        print("[ERROR-STATE] Attempted to switch to nil state")
    end
end
```

---

### **🔹 3. Inline Comments (For Complex Logic)**
Use sparingly to **clarify non-obvious code**.
```lua
function Dialogue:keypressed(key)
    local node = self.dialogue_tree[self.current_node]

    -- Check if the key is a valid number corresponding to a dialogue option
    if key >= '1' and key <= tostring(#node.options) then
        local choice_index = tonumber(key)
        self:setNode(node.options[choice_index].next) -- Move to the next dialogue node
    end
end
```

---

### **📌 4. Example for a Complete Lua File**
```lua
--[[
    Game State Manager
    Handles game states and transitions between them.
--]]

local State = {}
local currentState = nil

--[[
    Switches the current game state.
    @param state (table) - The new state module to switch to.
--]]
function State:switch(state)
    if state then
        -- Call leave() on the previous state if applicable
        if self.currentState and self.currentState.leave then
            self.currentState:leave()
        end

        -- Switch to the new state and call enter() if applicable
        self.currentState = state
        if self.currentState.enter then
            self.currentState:enter()
        end
    else
        print("[ERROR-STATE] Attempted to switch to nil state")
    end
end

--[[
    Updates the current game state.
    @param dt (number) - Delta time since last frame.
--]]
function State:update(dt)
    if self.currentState and self.currentState.update then
        self.currentState:update(dt)
    end
end

--[[
    Renders the current game state.
--]]
function State:draw()
    if self.currentState and self.currentState.draw then
        self.currentState:draw()
    end
end

return State
```
