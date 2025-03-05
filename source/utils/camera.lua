local Camera = {}
Camera.__index = Camera

--[[
    Create a new camera instance.
    @param screen_width (number)
    @param screen_height (number)
    @return (table)
--]]
function Camera:new(screen_width, screen_height)
    local instance = setmetatable({}, Camera)

    -- Camera position in pixels
    instance.x = 0
    instance.y = 0
    instance.screen_width = screen_width
    instance.screen_height = screen_height
    instance.map_width = 0
    instance.map_height = 0
    instance.scale = 1

    return instance
end

--[[
    Sets the boundaries of the map to prevent scrolling beyond them
    @param map_width (number)
    @param map_height (number)
    @param tile_size (number)
--]]
function Camera:setBounds(map_width, map_height, tile_size)
    self.map_width = map_width * tile_size
    self.map_height = map_height * tile_size
end

--[[
    Update the cameras to centre on bunny while staying within map bounds.
    @param target_x (number)
    @param target_y (number)
--]]
function Camera:update(target_x, target_y)
    -- Centre the camera on bunny
    local mid_w = (self.screen_width / self.scale) / 2
    local mid_h = (self.screen_height / self.scale) / 2
    self.x = math.floor(target_x - mid_w)
    self.y = math.floor(target_y - mid_h)
    -- Keep camera within map bounds
    self.x = math.max(0, math.min(self.x, self.map_width - self.screen_width / self.scale))
    self.y = math.max(0, math.min(self.y, self.map_height - self.screen_height / self.scale))
end

-- apply camera transformations.
function Camera:attach()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

-- removes camera transformations.
function Camera:detach()
    love.graphics.pop()
end

return Camera