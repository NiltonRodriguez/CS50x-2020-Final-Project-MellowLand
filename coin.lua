--[[
    Contains the coins information.
]]
local Coins       = {}
Coins.__index     = Coins
local ActiveFire  = {}
local ActiveWater = {}
local ActiveWind  = {}
local Player      = require 'Player'
--[[
    Function to remove the current Coins.
]]
function Coins.removeAll()
    -- Remove fire coins.
    for i,v in ipairs(ActiveFire) do
        v.physics.body:destroy()
    end
    ActiveFire = {}
    -- Remove water coins.
    for i,v in ipairs(ActiveWater) do
        v.physics.body:destroy()
    end
    ActiveWater = {}
    -- Remove wind coins.
    for i,v in ipairs(ActiveWind) do
        v.physics.body:destroy()
    end
    ActiveWind = {}
end
--[[
    Function to create new coins.
]]
-- Create fire coins.
function Coins.newFire(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Coins)
    -- Set the coin position.
    instance.x = x
    instance.y = y
    -- Set the coin image.
    instance.img = love.graphics.newImage('assets/Extras/coins/coinFire.png')
    -- Set the coin dimentions.
    instance.width  = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1
    -- Set the remove variable.
    instance.toBeRemoved = false
    -- Set the coin collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'static')
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new fire coin on the table.
    table.insert(ActiveFire, instance)
end
-- Create water coins.
function Coins.newWater(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Coins)
    -- Set the coin position.
    instance.x = x
    instance.y = y
    -- Set the coin image.
    instance.img = love.graphics.newImage('assets/Extras/coins/coinWater.png')
    -- Set the coin dimentions.
    instance.width  = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1
    -- Set the remove variable.
    instance.toBeRemoved = false
    -- Set the coin collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'static')
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new water coin on the table.
    table.insert(ActiveWater, instance)
end
-- Create wind coins.
function Coins.newWind(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Coins)
    -- Set the coin position.
    instance.x = x
    instance.y = y
    -- Set the coin image.
    instance.img = love.graphics.newImage('assets/Extras/coins/coinWind.png')
    -- Set the coin dimentions.
    instance.width  = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1
    -- Set the remove variable.
    instance.toBeRemoved = false
    -- Set the coin collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'static')
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new wind coin on the table.
    table.insert(ActiveWind, instance)
end
--[[
    Function to remove the coins.
]]
function Coins:remove()
    local destroy, fire, water, wind = false
    -- Remove fire coins.
    for i,instance in ipairs(ActiveFire) do
        if instance == self then
            destroy = true
            fire = true
        end
    end
    -- Remove water coins.
    for i,instance in ipairs(ActiveWater) do
        if instance == self then
            destroy = true
            water = true
        end
    end
    -- Remove wind coins.
    for i,instance in ipairs(ActiveWind) do
        if instance == self then
            destroy = true
            wind = true
        end
    end
    -- Condition to eliminate the coins from the tables.
    -- Add the coin to the player when eliminate a coin.
    if destroy == true then
        Player.sfx['power']:setVolume(0.25)
        Player.sfx['power']:play()
        self.physics.body:destroy()
        if fire then
            table.remove(ActiveFire, i)
            Player:hasfireCoins()
        elseif water then
            table.remove(ActiveWater, i)
            Player:haswaterCoins()
        elseif wind then
            table.remove(ActiveWind, i)
            Player:haswindCoins()
        end
    end
end
--[[
    Function to update the coins.
]]
function Coins:update(dt)
    self:spin(dt)
    self:checkRemove()
end
--[[
    Function to check to remove the coins.
]]
function Coins:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end
--[[
    Function to animate the coins.
]]
function Coins:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2)
end
--[[
    Function to render coins.
]]
function Coins:render()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end
--[[
    Function to update all the coins.
]]
function Coins.updateAll(dt)
    -- Update fire coins.
    for i,instance in ipairs(ActiveFire) do
        instance:update(dt)
    end
    -- Update water coins.
    for i,instance in ipairs(ActiveWater) do
        instance:update(dt)
    end
    -- Update wind coins.
    for i,instance in ipairs(ActiveWind) do
        instance:update(dt)
    end
end
--[[
    Function to render all coins.
]]
function Coins.renderAll()
    -- Render fire coins.
    for i,instance in ipairs(ActiveFire) do
        instance:render()
    end
    -- Render water coins.
    for i,instance in ipairs(ActiveWater) do
        instance:render()
    end
    -- Tender wind coins.
    for i,instance in ipairs(ActiveWind) do
        instance:render()
    end
end
--[[
    Function to check for collitions.
]]
function Coins.beginContact(a, b, collition)
    -- Check collision for fire coins.
    for i,instance in ipairs(ActiveFire) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
    -- Check collision for water coins.
    for i,instance in ipairs(ActiveWater) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
    -- Check collision for wind coins.
    for i,instance in ipairs(ActiveWind) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return Coins
