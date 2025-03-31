local SceneManager = {
    current_scene = nil,
    current_name = nil,
}

function SceneManager:switch(scene_name, from_scene)
    local scene_classes = {
        archives = require 'source.scenes.archives',
        library = require 'source.scenes.library',
        -- Add scenes here
    }

    local SceneClass = scene_classes[scene_name]
    if not SceneClass then
        print("[ERROR]<SceneManager> Scene not found.")
        return
    end

    self.current_scene = SceneClass:new(from_scene)
    self.current_name = scene_name
    print("[DEBUG]<SceneManager> Switched to scene: ", scene_name)
end

function SceneManager:update(dt)
    if self.current_scene and self.current_scene.update then
        self.current_scene:update(dt)
        if self.current_scene.checkForSceneSwitch then
            local next = self.current_scene:checkForSceneSwitch()
            if next then
                self:switch(next, self.current_name)
            end
        end
    end
end

function SceneManager:draw()
    if self.current_scene and self.current_scene.update then
        self.current_scene:draw()
    end
end

function SceneManager:keypressed(key)
    if self.current_scene and self.current_scene.keypressed then
        self.current_scene:keypressed(key)
    end
end

function SceneManager:mousepressed(x, y, button)
    if self.current_scene and self.current_scene.mousepressed then
        self.current_scene:mousepressed(x, y, button)
    end
end

function SceneManager:interact()
    if self.current_scene and self.current_scene.interact then
        self.current_scene:interact()
    end
end

return SceneManager