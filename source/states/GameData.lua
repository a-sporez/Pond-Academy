local GameData = {
    unlocked_scenes = {
        library   = false,
        sanctum   = false,
        labyrinth = false,
        atrium    = false
    },
    flags = {},
    bunny_position = nil,
}

-- Unlock a scene by name
function GameData:setSceneUnlocked(scene_name)
    self.unlocked_scenes[scene_name] = true
end

-- check if a scene is unlocked
function GameData:isSceneUnlocked(scene_name)
    return self.unlocked_scenes[scene_name] or false
end

-- set boolean or value flag
function GameData:setFlag(key, value)
    self.flags[key] = value
end

-- retrieve a stored flag
function GameData:getFlag(key)
    return self.flags[key]
end

-- save bunny's last know location
function GameData:getBunnyPosition()
    return self.bunny_position
end

-- reset all states
function GameData:reset()
    self.unlocked_scenes = {
        library   = false,
        sanctum   = false,
        labyrinth = false,
        atrium    = false
    }
    self.flags = {}
    self.bunny_position = nil
end

return GameData