--[[
    Allow to move for all the map, not just the window space.
]]
local Player = require 'Player'
local Camera = {
    x = 0,
    y = 0,
    scale = 1
}
--[[
    Function to apply the camera movement.
]]
function Camera:apply()
    love.graphics.translate(math.floor(-self.x), math.floor(-self.y))
end
--[[
    Function to move the camera.
]]
function Camera:setPosition(x, y)
    -- Initialize camera position.
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y
    -- Stop the camera on the edges of the map.
    -- Left and right edges.
    self.x = math.max(0, math.min(Player.x - WINDOW_WIDTH / 2, math.min(MapWidth - WINDOW_WIDTH, Player.x)))
    -- Top and bottom edges.
    self.y = math.max(0, math.min(Player.y - WINDOW_HEIGHT / 2, math.min(MapHeight - WINDOW_HEIGHT, Player.y)))
end

return Camera
