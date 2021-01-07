--[[
    Contains the map information.
]]
local Map = {}
local STI = require ('sti')
local Box = require 'box'
local Cloud = require 'cloud'
local Coin = require 'coin'
local Enemy = require 'enemy'
local Flag = require 'flag'
local Player = require 'Player'
--[[
    Contains the map initial data.
]]
function Map:load()
    -- Track the current level.
    self.currentLevel = 0
    -- Initialize the world physics.
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    -- Function to load the current map.
    self:init()
end
--[[
    Function to reset and load the maps.
]]
function Map:init()
    -- Initialize the map.
    self.level       = STI('map/'..self.currentLevel..'.lua', {'box2d'})
    self.solidLayer  = self.level.layers.solid
    self.entityLayer = self.level.layers.entity
    self.floorLayer  = self.level.layers.Floor
    -- Set the map size
    MapWidth  = self.floorLayer.width * 100
    MapHeight = self.floorLayer.height * 100
    -- Load the collidables.
    self.level:box2d_init(World)
    self.solidLayer.visible  = false
    self.entityLayer.visible = false
    -- Initialize the entities.
    self:spawnEntities()
end
--[[
    Functions to load the new level.
]]
function Map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1
    self:init()
    Player:resetPosition()
end
--[[
    Functions to clean the previous level.
]]
function Map:clean()
    self.level:box2d_removeLayer('solid')
    Box.removeAll()
    Cloud.removeAll()
    Enemy.removeAll()
    Coin:removeAll()
    Flag.removeAll()
end
--[[
    Functions to spawn the entities in the map.
]]
function Map:spawnEntities()
    for i,v in ipairs(self.entityLayer.objects) do
        -- Initialize the clouds.
        if v.type == 'cloud' then
            Cloud.new(v.x + v.width / 2, v.y + v.height / 2)
        -- Initialize the boxes.
        elseif v.type == 'box' then
            Box.new(v.x + v.width / 2, v.y + v.height / 2)
        -- Initialize the Fire coins.
        elseif v.type == 'ficoin' then
            Coin.newFire(v.x + v.width / 2, v.y + v.height / 2)
        -- Initialize the Water coins.
        elseif v.type == 'wacoin' then
            Coin.newWater(v.x + v.width / 2, v.y + v.height / 2)
        -- Initialize the Wind coins.
        elseif v.type == 'wicoin' then
            Coin.newWind(v.x + v.width / 2, v.y + v.height / 2)
        -- Initialize Beh.
        elseif v.type == 'beh' then
            Enemy.newBeh(v.x + v.width / 2, v.y + v.height / 2)
        -- Initialize Cal.
        elseif v.type == 'cal' then
            Enemy.newCal(v.x + v.width / 2, v.y + v.height / 2)
        -- Initialize Squ.
        elseif v.type == 'squ' then
            Enemy.newSqu(v.x + v.width / 2, v.y + v.height / 2)
        -- initialize the flag.
        elseif v.type == 'flag' then
            Flag.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end


return Map
