--[[
    Contains the box information.
]]
local Box       = {}
Box.__index     = Box
local ActiveBox = {}
local Player    = require 'Player'
--[[
    Function to remove the current boxes.
]]
function Box.removeAll()
    for i,v in ipairs(ActiveBox) do
        v.physics.body:destroy()
    end
    ActiveBox = {}
end
--[[
    Function to create new box.
]]
function Box.new(x, y)
    -- Initialize a metatable.
    local instance = setmetatable({}, Box)
    -- Set the box position.
    instance.x = x
    instance.y = y
    -- Set the box image.
    instance:loadAssets()
    -- Set the box dimentions.
    instance.width  = 100
    instance.height = 100
    -- Set the remove variable.
    instance.toBeChanged = false
    -- Set the box collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'static')
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new boxes on the table.
    table.insert(ActiveBox, instance)
end
--[[
    Function to load the box images.
]]
function Box:loadAssets()
    self.animation = {img = {
        [1] = love.graphics.newImage('assets/Extras/box/box_yel.png'),
        [2] = love.graphics.newImage('assets/Extras/box/box_blu.png')
        }
    }
    self.animation.draw = self.animation.img[1]
end
--[[
    Function to set the new the box.
]]
function Box:Change()
    for i,instance in ipairs(ActiveBox) do
        if instance == self then
            self.animation.draw = self.animation.img[2]
        end
    end
end
--[[
    Function to update the box.
]]
function Box:update(dt)
    self:checkChange()
end
--[[
    Function to change the box.
]]
function Box:checkChange()
    if self.toBeChanged then
        self:Change()
    end
end
--[[
    Function to render box.
]]
function Box:render()
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end
--[[
    Function to update all the boxes.
]]
function Box.updateAll(dt)
    for i,instance in ipairs(ActiveBox) do
        instance:update(dt)
    end
end
--[[
    Function to render all boxes.
]]
function Box.renderAll()
    for i,instance in ipairs(ActiveBox) do
        instance:render()
    end
end
--[[
    Function to check for collitions.
]]
function Box.beginContact(a, b, collision)
    if Player.dy < 0 then
        for i,instance in ipairs(ActiveBox) do
            if a == instance.physics.fixture or b == instance.physics.fixture then
                if a == Player.physics.fixture or b == Player.physics.fixture then
                    if instance.toBeChanged == false then
                        -- Increment the boxes.
                        Player.boxes         = Player.boxes + 1
                        instance.toBeChanged = true
                        Player.sfx['coin']:setVolume(0.25)
                        Player.sfx['coin']:play()
                        -- Increment Player health by 1 per each 15 boxes.
                        if (Player.boxes % 15 == 0) and Player.boxes ~= 0 then
                            Player.health.current = Player.health.current + 1
                        end
                    end
                    return true
                end
            end
        end
    end
end

return Box
