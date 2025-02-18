local Bunny = {}
Bunny.__index = Bunny

--[[ 
    Creates a new Bunny entity.
    @param pos_x (number) - Initial X position (in pixels).
    @param pos_y (number) - Initial Y position (in pixels).
    @return (table) - A new Bunny instance.
--]]
function Bunny:new(pos_x, pos_y)
    local instance = setmetatable({}, Bunny)
    instance.pos_x = math.floor(pos_x / 32) * 32
    instance.pos_y = math.floor(pos_y / 32) * 32
    instance.sprite = love.graphics.newImage("assets/sprites/bunny.png")
    return instance
end

--[[ 
    Draws Bunny at its position.
--]]
function Bunny:draw()
    love.graphics.draw(self.sprite, self.pos_x, self.pos_y)
end

--[[ 
    Updates Bunny (currently unused but available for future behavior).
    @param dt (number) - Delta time.
--]]
function Bunny:update(dt)
    -- Future movement animations or other logic can go here.
end

--[[ 
    Handles key input and attempts movement.
    @param key (string) - The key pressed.
    @param archives (table) - The Archives scene reference for collision checks.
--]]
function Bunny:keypressed(key, archives)
    local new_x = self.pos_x
    local new_y = self.pos_y

    if key == "up" then
        new_y = self.pos_y - 32  -- Normal -Y movement (up)
    elseif key == "down" then
        new_y = self.pos_y + 32  -- Normal +Y movement (down)
    elseif key == "left" then
        new_x = self.pos_x - 32
    elseif key == "right" then
        new_x = self.pos_x + 32
    elseif key == "e" then
        archives:interact()
        return
    end

    if not archives:isCollidingWithWall(new_x, new_y) then
        self.pos_x = new_x
        self.pos_y = new_y
        print("[DEBUG] Bunny moved to:", self.pos_x, self.pos_y)
    else
        print("[DEBUG] Collision detected! Move blocked.")
    end
end

return Bunny
