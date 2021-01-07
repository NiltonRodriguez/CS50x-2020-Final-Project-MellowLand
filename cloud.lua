--[[
    Contains the damage cloud information.
]]
local Cloud         = {img = love.graphics.newImage('assets/Extras/cloud/cloud.png')}
Cloud.__index       = Cloud
Cloud.width         = Cloud.img:getWidth()
Cloud.height        = Cloud.img:getHeight()
local ActiveCloud   = {}
local Player        = require 'Player'
--[[
    Function to remove the current clouds.
]]
function Cloud.removeAll()
    for i,v in ipairs(ActiveCloud) do
        v.physics.body:destroy()
    end
    ActiveCloud = {}
end
--[[
    Function to create new cloud.
]]
function Cloud.new(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Cloud)
    -- Set the cloud position.
    instance.x = x
    instance.y = y
    -- Set the cloud damage.
    instance.damage = 1
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'static')
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new clouds in the table.
    table.insert(ActiveCloud, instance)
end
--[[
    Function to render clouds.
]]
function Cloud:render()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end
--[[
    Function to render all clouds.
]]
function Cloud.renderAll()
    for i,instance in ipairs(ActiveCloud) do
        instance:render()
    end
end
--[[
    Function to check for collitions.
]]
function Cloud.beginContact(a, b, collision)
    for i,instance in ipairs(ActiveCloud) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                -- Make damage to the player.
                Player:takeDamage(instance.damage)
                Player.sfx['hit']:play()
                return true
            end
        end
    end
end

return Cloud
