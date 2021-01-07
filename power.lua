--[[
    Contains the Power information.
]]
local Power        = {}
Power.__index      = Power
local ActiveFlame  = {}
local ActiveBubble = {}
local ActiveBreeze = {}
--[[
    Function to remove the current Power.
]]
function Power.removeAll()
    -- Remove flames
    for i,v in ipairs(ActiveFlame) do
        v.physics.body:destroy()
    end
    ActiveFlame = {}
    -- Remove bubbles.
    for i,v in ipairs(ActiveBubble) do
        v.physics.body:destroy()
    end
    ActiveBubble = {}
    -- Remove breeze.
    for i,v in ipairs(ActiveBreeze) do
        v.physics.body:destroy()
    end
    ActiveBreeze = {}
end
--[[
    Function to create a new Power.
]]
-- Create flames.
function Power.newFlame(x, y, dir)
    -- Initialize the metatable.
    local instance = setmetatable({}, Power)
    -- Set the Flame position.
    instance.x   = x
    instance.y   = y
    instance.dir = dir
    -- Set the movement speed.
    instance.speed = 500
    instance.dx    = instance.speed
    instance.img   = Power.img[1]
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'dynamic')
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new Flame in the table.
    table.insert(ActiveFlame, instance)
end
-- Create bubbles.
function Power.newBubble(x, y, dir)
    -- Initialize the metatable.
    local instance = setmetatable({}, Power)
    -- Set the Bubble position.
    instance.x   = x
    instance.y   = y
    instance.dir = dir
    -- Set the movement speed.
    instance.speed = 500
    instance.dx    = instance.speed
    instance.img   = Power.img[2]
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'dynamic')
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new Bubble in the table.
    table.insert(ActiveBubble, instance)
end
-- Create breeze.
function Power.newBreeze(x, y, dir)
    -- Initialize the metatable.
    local instance = setmetatable({}, Power)
    -- Set the Breeze position.
    instance.x   = x
    instance.y   = y
    instance.dir = dir
    -- Set the movement speed.
    instance.speed = 500
    instance.dx    = instance.speed
    instance.img   = Power.img[3]
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'dynamic')
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new Breeze in the table.
    table.insert(ActiveBreeze, instance)
end
--[[
    Function to load the images.
]]
function Power.loadAssets()
    -- Set the image for each power.
    Power.img = {
        [1] = love.graphics.newImage('assets/Extras/powers/flame.png'),
        [2] = love.graphics.newImage('assets/Extras/powers/bubble.png'),
        [3] = love.graphics.newImage('assets/Extras/powers/breeze.png')
    }
    -- Get the size of the image.
    Power.width  = Power.img[1]:getWidth()
    Power.height = Power.img[1]:getHeight()
end
--[[
    Function to syncronize the physical body with Power position.
]]
function Power:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    if self.dir == 'right' then
        self.physics.body:setLinearVelocity(self.dx, 0)
    elseif self.dir == 'left' then
        self.physics.body:setLinearVelocity(-self.dx, 0)
    end
end
--[[
    Function to update the Powers.
]]
function Power:update(dt)
    self:syncPhysics()
end
--[[
    Function to render Powers.
]]
function Power:render()
    local scaleX = 1
    if self.dir == 'left' then
        scaleX = -1
    end
    love.graphics.draw(self.img, self.x, self.y, 0, scaleX, 1, self.width / 2, self.height / 2)
end
--[[
    Function to reach active power.
]]
-- Index active flames.
function Power.getActiveFlame()
    return ActiveFlame
end
-- Index active bubbles.
function Power.getActiveBubble()
    return ActiveBubble
end
-- Index active breeze.
function Power.getActiveBreeze()
    return ActiveBreeze
end
--[[
    Function to update all the Powers.
]]
function Power.updateAll(dt)
    -- Update the flames.
    for i,instance in ipairs(ActiveFlame) do
        instance:update(dt)
    end
    -- Update the bubbles.
    for i,instance in ipairs(ActiveBubble) do
        instance:update(dt)
    end
    -- Update the breeze.
    for i,instance in ipairs(ActiveBreeze) do
        instance:update(dt)
    end
end
--[[
    Function to render all the Powers.
]]
function Power.renderAll()
    -- Render the flames.
    for i,instance in ipairs(ActiveFlame) do
        instance:render()
    end
    -- Render the bubbles.
    for i,instance in ipairs(ActiveBubble) do
        instance:render()
    end
    -- Render the breeze.
    for i,instance in ipairs(ActiveBreeze) do
        instance:render()
    end
end
--[[
    Function to check for collitions.
]]
function Power.beginContact(a, b, collision)
    -- Check collision for flames.
    for i,instance in ipairs(ActiveFlame) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.physics.body:destroy()
            table.remove(ActiveFlame, i)
        end
    end
    -- Check collision for bubbles.
    for i,instance in ipairs(ActiveBubble) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.physics.body:destroy()
            table.remove(ActiveBubble, i)
        end
    end
    -- Check collision for breeze.
    for i,instance in ipairs(ActiveBreeze) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.physics.body:destroy()
            table.remove(ActiveBreeze, i)
        end
    end
end

return Power
