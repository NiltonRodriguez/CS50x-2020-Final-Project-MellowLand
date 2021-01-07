--[[
    Contains the flag information.
]]
local Flag       = {img = love.graphics.newImage('assets/Extras/flag/1.png')}
Flag.__index     = Flag
Flag.width       = Flag.img:getWidth()
Flag.height      = Flag.img:getHeight()
local ActiveFlag = {}
local Player     = require 'Player'
--[[
    Function to remove the current flag.
]]
function Flag.removeAll()
    for i,v in ipairs(ActiveFlag) do
        v.physics.body:destroy()
    end
    ActiveFlag = {}
end
--[[
    Function to create new flag.
]]
function Flag.new(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Flag)
    -- Set the flag position.
    instance.x = x
    instance.y = y
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'static')
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new clouds in the table.
    table.insert(ActiveFlag, instance)
end
--[[
    Function to render flags.
]]
function Flag:render()
    love.graphics.draw(self.img, self.x, self.y - 100, 0, 1, 1, 50, 50)

end
--[[
    Function to render all flags.
]]
function Flag.renderAll()
    for i,instance in ipairs(ActiveFlag) do
        instance:render()
    end
end
--[[
    Function to check for collitions.
]]
function Flag.beginContact(a, b, collision)
    for i,instance in ipairs(ActiveFlag) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                local playvic = false
                -- Change the game state for each stage.
                if gameState == 'intro' then
                    gameState = 'scorei'
                    playvic = true
                elseif gameState == 'stage1' then
                    gameState = 'score1'
                    playvic = true
                elseif gameState == 'stage2' then
                    gameState = 'score2'
                    playvic = true
                elseif gameState == 'stage3' then
                    gameState = 'score3'
                    playvic = true
                end
                if playvic then
                    -- Stop the stage music.
                    music['stage']:stop()
                    Player.sfx['hit']:stop()
                    Player.sfx['jump']:stop()
                    -- Play the victory music.
                    music['victory']:setLooping(true)
                    music['victory']:play()
                end
                return true
            end
        end
    end
end

return Flag
