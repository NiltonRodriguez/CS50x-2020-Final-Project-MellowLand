--[[
    Contains the enemy information.
]]
local Enemy     = {}
Enemy.__index   = Enemy
local ActiveBeh = {}
local ActiveCal = {}
local ActiveSqu = {}
local Player    = require 'Player'
local Power     = require 'power'
--[[
    Function to remove the current Enemy.
]]
function Enemy.removeAll()
    -- Remove active Beh.
    for i,v in ipairs(ActiveBeh) do
        v.physics.body:destroy()
    end
    ActiveBeh = {}
    -- Remove active Cal.
    for i,v in ipairs(ActiveCal) do
        v.physics.body:destroy()
    end
    ActiveCal = {}
    -- Remove active Squ.
    for i,v in ipairs(ActiveSqu) do
        v.physics.body:destroy()
    end
    ActiveSqu = {}
end
--[[
    Function to create new enemy.
]]
-- Create Beh.
function Enemy.newBeh(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Enemy)
    -- Set Beh position.
    instance.x = x
    instance.y = y
    -- Set the movement speed.
    instance.speed    = 75
    instance.dx       = math.random(2) == 1 and - instance.speed or instance.speed
    instance.dy       = 0
    instance.gravity  = 1500
    -- Set the animation variables.
    instance.state          = 'fly'
    instance.animation      = {timer = 0, rate = 0.05}
    instance.animation.fly  = {total = 4, current = 1, img = Enemy.anim.Beh.flyAnim}
    instance.animation.die  = {total = 1, current = 1, img = Enemy.anim.Beh.dieAnim}
    instance.animation.draw = instance.animation.fly.img[1]
    -- Set Beh size.
    instance.width  = Enemy.anim.Beh.width
    instance.height = Enemy.anim.Beh.height
    -- Set Beh damage.
    instance.damage = 1
    instance.health = 2
    -- Set the remove variable.
    instance.toBeRemoved = false
    -- Store colors.
    instance.color = {
        red   = 1,
        green = 1,
        blue  = 1,
        speed = 0.01
    }
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'dynamic')
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new enemy Behs in the table.
    table.insert(ActiveBeh, instance)
end
-- Create Cal.
function Enemy.newCal(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Enemy)
    -- Set Cal position.
    instance.x = x
    instance.y = y
    -- Set the movement speed.
    instance.speed    = 100
    instance.dx       = math.random(2) == 1 and - instance.speed or instance.speed
    instance.dy       = 0
    instance.gravity  = 1500
    -- Set the animation variables.
    instance.state          = 'walk'
    instance.animation      = {timer = 0, rate = 0.2}
    instance.animation.walk = {total = 4, current = 1, img = Enemy.anim.Cal.walkAnim}
    instance.animation.die  = {total = 1, current = 1, img = Enemy.anim.Cal.dieAnim}
    instance.animation.draw = instance.animation.walk.img[1]
    -- Set Cal size.
    instance.width  = Enemy.anim.Cal.width
    instance.height = Enemy.anim.Cal.height
    -- Set Cal damage.
    instance.damage = 1
    instance.health = 2
    -- Set the remove variable.
    instance.toBeRemoved = false
    -- Store colors.
    instance.color = {
        red   = 1,
        green = 1,
        blue  = 1,
        speed = 0.8
    }
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'dynamic')
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new enemy in the table.
    table.insert(ActiveCal, instance)
end
-- Create Squ.
function Enemy.newSqu(x, y)
    -- Initialize the metatable.
    local instance = setmetatable({}, Enemy)
    -- Set the enemy Squ position.
    instance.x = x
    instance.y = y
    -- Set the movement speed.
    instance.speed = 75
    instance.dx    = math.random(2) == 1 and - instance.speed or instance.speed
    -- Set the jumping variables.
    instance.dy       = 0
    instance.jump_Vel = -700
    instance.grounded = false
    instance.gravity  = 1500
    -- Set the animation variables.
    instance.state          = 'jump'
    instance.animation      = {timer = 0, rate = 0.25}
    instance.animation.jump = {total = 4, current = 1, img = Enemy.anim.Squ.jumpAnim}
    instance.animation.die  = {total = 1, current = 1, img = Enemy.anim.Squ.dieAnim}
    instance.animation.draw = instance.animation.jump.img[1]
    -- Set Squ size.
    instance.width  = Enemy.anim.Squ.width
    instance.height = Enemy.anim.Squ.height
    -- Set Squ damage.
    instance.damage = 1
    instance.health = 2
    -- Set the remove variable.
    instance.toBeRemoved = false
    -- Store colors.
    instance.color = {
        red   = 1,
        green = 1,
        blue  = 1,
        speed = 0.8
    }
    -- Set the collision table.
    instance.physics         = {}
    instance.physics.body    = love.physics.newBody(World, instance.x, instance.y, 'dynamic')
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape   = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    -- Insert the new enemy Squs in the table.
    table.insert(ActiveSqu, instance)
end
--[[
    Function to load the animations.
]]
function Enemy.init()
    Enemy.anim = {}
        -- Load Beh animations.
        Enemy.anim.Beh = {}
            -- Fly animation.
            Enemy.anim.Beh.flyAnim = {}
            -- Store individual frames.
            for i = 1, 4 do
                Enemy.anim.Beh.flyAnim[i] = love.graphics.newImage('assets/Enemy/Beh/walk/'..i..'.png')
            end
            -- Die animation.
            Enemy.anim.Beh.dieAnim = love.graphics.newImage('assets/Enemy/Beh/die/1.png')
            -- Get the size of the image.
            Enemy.anim.Beh.width  = Enemy.anim.Beh.flyAnim[1]:getWidth()
            Enemy.anim.Beh.height = Enemy.anim.Beh.flyAnim[1]:getHeight()
        -- Load Cal animations.
        Enemy.anim.Cal = {}
            -- Walk animation.
            Enemy.anim.Cal.walkAnim = {}
            -- Store individual frames.
            for i = 1, 4 do
                Enemy.anim.Cal.walkAnim[i] = love.graphics.newImage('assets/Enemy/Cal/walk/'..i..'.png')
            end
            -- Die animation.
            Enemy.anim.Cal.dieAnim = love.graphics.newImage('assets/Enemy/Cal/die/1.png')
            -- Get the size of the image.
            Enemy.anim.Cal.width  = Enemy.anim.Cal.walkAnim[1]:getWidth()
            Enemy.anim.Cal.height = Enemy.anim.Cal.walkAnim[1]:getHeight()
        -- Load Squ animations.
        Enemy.anim.Squ = {}
            -- Jump animation.
            Enemy.anim.Squ.jumpAnim = {}
            -- Store individual frames.
            for i = 1, 4 do
                Enemy.anim.Squ.jumpAnim[i] = love.graphics.newImage('assets/Enemy/Squ/walk/'..i..'.png')
            end
            -- Die animation.
            Enemy.anim.Squ.dieAnim = love.graphics.newImage('assets/Enemy/Squ/die/1.png')
            -- Get the size of the image.
            Enemy.anim.Squ.width  = Enemy.anim.Squ.jumpAnim[1]:getWidth()
            Enemy.anim.Squ.height = Enemy.anim.Squ.jumpAnim[1]:getHeight()

end
--[[
    Function to flip the direction.
]]
function Enemy:flipDirection()
    self.dx = -self.dx
end
--[[
    Function to remove the enemys.
]]
function Enemy:remove()
    self.physics.body:destroy()
    -- Remove Beh.
    for i,instance in ipairs(ActiveBeh) do
        if instance == self then
            table.remove(ActiveBeh, i)
        end
    end
    -- Remove Cal.
    for i,instance in ipairs(ActiveCal) do
        if instance == self then
            table.remove(ActiveCal, i)
        end
    end
    -- Remove Squ.
    for i,instance in ipairs(ActiveSqu) do
        if instance == self then
            table.remove(ActiveSqu, i)
        end
    end
end
-- Function to tint red when take damage.
function Enemy:tintRed()
    self.color.green = 0
    self.color.blue  = 0
    self.animation.draw = self.animation.die.img
end
-- Function to untint the enemy.
function Enemy:untint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end
--[[
    Function apply the gravity.
]]
function Enemy:applyGravity(dt)
    if not self.grounded then
        self.dy = self.dy + self.gravity * dt
    end
end
--[[
    Function to check items below Enemy.
]]
function Enemy:land(collision)
    self.currentGroundCollision = collision
    self.dy                     = 0
    self.grounded               = true
end
--[[
    Jump function.
]]
function Enemy:jump()
    if self.grounded then
        self.dy         = self.jump_Vel
        self.grounded   = false
    end
end
--[[
    Function to apply the animations.
]]
function Enemy:animate(dt)
    -- Increment the timer.
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end
--[[
    Function to update the image to draw.
]]
function Enemy:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end
--[[
    Function to syncronize the physical body with position.
]]
function Enemy:syncPhysics(tab)
    self.x, self.y = self.physics.body:getPosition()
    -- Sync Beh.
    if tab == ActiveBeh then
        self.physics.body:setLinearVelocity(self.dx, 0)
    -- Sync Cal.
    elseif tab == ActiveCal then
        self.physics.body:setLinearVelocity(self.dx, 200)
    -- Sync Squ.
    elseif tab == ActiveSqu then
        self.physics.body:setLinearVelocity(self.dx, self.dy)
    end
end
--[[
    Function to update the enemy.
]]
function Enemy:update(dt)
    self:animate(dt)
    self:applyGravity(dt)
    self:jump()
    self:syncPhysics(tab)
    self:checkRemove()
    self:untint(dt)
end
--[[
    Function to check to remove the enemys.
]]
function Enemy:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end
--[[
    Function to render enemy.
]]
-- Render Cal and Squ.
function Enemy:render()
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
    love.graphics.setColor(1, 1, 1, 1)
end
-- Render Beh.
function Enemy:renderBeh()
    local scaleX = -1
    if self.dx < 0 then
        scaleX = 1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.width / 2, self.height / 2)
end
--[[
    Function to update all the enemys.
]]
function Enemy.updateAll(dt)
    -- Update Beh.
    for i,instance in ipairs(ActiveBeh) do
        tab = ActiveBeh
        instance:update(dt)
    end
    -- Update Cal.
    for i,instance in ipairs(ActiveCal) do
        tab = ActiveCal
        instance:update(dt)
    end
    -- Update Cal.
    for i,instance in ipairs(ActiveSqu) do
        tab = ActiveSqu
        instance:update(dt)
    end
end
--[[
    Function to render all enemys.
]]
function Enemy.renderAll()
    -- Render Beh.
    for i,instance in ipairs(ActiveBeh) do
        instance:renderBeh()
    end
    -- Render Cal.
    for i,instance in ipairs(ActiveCal) do
        instance:render()
    end
    -- Render Squ.
    for i,instance in ipairs(ActiveSqu) do
        instance:render()
    end
end
--[[
    Function to check for collitions.
]]
function Enemy.beginContact(a, b, collision)
    -- Check collision for Beh.
    for i,instance in ipairs(ActiveBeh) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            -- Make damage to the player.
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                Player.sfx['hit']:play()
            end
            -- Change direction when collide.
            instance:flipDirection()
            for i,flame in ipairs(Power.getActiveFlame()) do
                if a == flame.physics.fixture or b == flame.physics.fixture then
                    -- Take damage from flames.
                    if instance.health > 1 then
                        instance:tintRed()
                        Player.sfx['boom']:play()
                        instance.health = instance.health - 1
                    -- Eliminate Beh.
                    elseif instance.health == 1 then
                        Player.sfx['boom']:play()
                        instance.toBeRemoved = true
                    end
                end
            end
        end
    end
    -- Check collision for Cal.
    for i,instance in ipairs(ActiveCal) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            -- Change direction when collide.
            instance:flipDirection()
            -- Make damage to the player.
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                Player.sfx['hit']:play()
            end
            for i,bubble in ipairs(Power.getActiveBubble()) do
                if a == bubble.physics.fixture or b == bubble.physics.fixture then
                    -- Take damage from bubbles.
                    if instance.health > 1 then
                        instance:tintRed()
                        Player.sfx['boom']:play()
                        instance.health = instance.health - 1
                    -- Eliminate Cal.
                    elseif instance.health == 1 then
                        Player.sfx['boom']:play()
                        instance.toBeRemoved = true
                    end
                end
            end
        end
    end
    -- Check collision for Scu.
    for i,instance in ipairs(ActiveSqu) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            -- Make damage to the player.
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                Player.sfx['hit']:play()
            end
            -- Check for collitions with objects below Squ.
            if instance.grounded then return end
            local nx, ny = collision:getNormal()
            if a == instance.physics.fixture then
                if ny > 0 then
                    instance:land(collision)
                elseif ny < 0 then
                    instance.dy = 0
                end
            elseif b == instance.physics.fixture then
                if ny < 0 then
                    instance:land(collision)
                elseif ny > 0 then
                    instance.dy = 0
                end
            end
            -- Change direction when collide.
            if not instance.grounded then
                instance:flipDirection()
            elseif not instance.grounded then
                instance:flipDirection()
            end
            for i,breeze in ipairs(Power.getActiveBreeze()) do
                if a == breeze.physics.fixture or b == breeze.physics.fixture then
                    -- Take damage from breeze.
                    if instance.health > 1 then
                        instance:tintRed()
                        Player.sfx['boom']:play()
                        instance.health = instance.health - 1
                    -- Eliminate Squ.
                    elseif instance.health == 1 then
                        Player.sfx['boom']:play()
                        instance.toBeRemoved = true
                    end
                end
            end
        end
    end
end
-- Function to check if a collision ended.
function Enemy:endContact(a, b, collision)
    for i,instance in ipairs(ActiveSqu) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if self.currentGroundCollision == collision then
                self.grounded = false
            end
        end
    end
end
return Enemy
