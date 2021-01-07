--[[
    Contains the player class.
]]
local Player = {}
local Power = require 'power'
--[[
    Function to initualize the player class.
]]
function Player:init()
    -- Set player position.
    self.x      = 100
    self.y      = 0
    self.startX = self.x
    self.startY = self.y
    -- Set the animations.
    self:loadAssets()
    self.direction = 'right'
    self.state     = 'idle'
    self.element   = 'mellow'
    -- Set the player size.
    self.width  = self.animation.width
    self.height = self.animation.height
    -- Set the player velocity.
    self.dx = 0
    self.dy = 0
    -- Set movement speed.
    self.maxSpeed = 350
    self.accel    = 4000
    self.friction = 3500
    -- Set the gravity.
    self.gravity  = 1500
    self.grounded = false
    -- Set the jump variables.
    self.jump_Vel       = -800
    self.graceTime      = 0
    self.graceDuration  = 0.1
    self.QuadJump       = 3
    -- Set Dash variables
    self.dashSpeed    = 1700
    self.dashTime     = 0
    self.dashDuration = 1
    -- Set the health variables.
    self.health = {current = 3, max = 3}
    -- Set the collectables variables.
    self.fireCoins  = false
    self.waterCoins = false
    self.windCoins  = false
    self.boxes      = 0
    -- Store colors.
    self.color = {
        red   = 1,
        green = 1,
        blue  = 1,
        speed = 2
    }
    -- Set the collision table.
    self.physics         = {}
    self.physics.body    = love.physics.newBody(World, self.x, self.y, 'dynamic')
    self.physics.body:setFixedRotation(true)
    self.physics.shape   = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    -- Initialize the sound effects.
    self.sfx = {
        ['jump']   = love.audio.newSource('sfx/Jump.wav', 'static'),
        ['hit']    = love.audio.newSource('sfx/Hit.wav', 'static'),
        ['coin']   = love.audio.newSource('sfx/Coin.wav', 'static'),
        ['power']  = love.audio.newSource('sfx/Powerup.wav', 'static'),
        ['dash']   = love.audio.newSource('sfx/Dash.wav', 'static'),
        ['change'] = love.audio.newSource('sfx/Change.wav', 'static'),
        ['flame']  = love.audio.newSource('sfx/Flame.wav', 'static'),
        ['bubble'] = love.audio.newSource('sfx/Bubble.wav', 'static'),
        ['breeze'] = love.audio.newSource('sfx/Breeze.wav', 'static'),
        ['boom']   = love.audio.newSource('sfx/Explosion.wav', 'static')
    }
end
--[[
    Function to update the player life and colletables.
]]
-- Function to increment the damage.
function Player:takeDamage(amount)
    self:tintRed()
    if self.health.current > 0 then
        self.health.current = self.health.current - amount
    else
        self.health.current = 0
        self:die()
    end
end
-- Function for the player death.
function Player:die()
    gameState = 'game_over'
end
-- Function for reset the player position.
function Player:resetPosition()
    self.physics.body:setPosition(self.startX, self.startY)
    self.element = 'mellow'
end
-- Function to increment the fire coins.
function Player:hasfireCoins()
    self.fireCoins = true
end
-- Function to increment the water coins.
function Player:haswaterCoins()
    self.waterCoins = true
end
-- Function to increment the wind coins.
function Player:haswindCoins()
    self.windCoins = true
end
-- Function to tint red when take damage.
function Player:tintRed()
    self.color.green = 0
    self.color.blue  = 0
    self.animation.draw = self.animation[self.element].hit.img[1]
end
-- Function to untint the player.
function Player:untint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end
--[[
    Function to update the player.
]]
function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:decreaseGraceTime(dt)
    self:decreaseDashTime(dt)
    self:setDirection()
    self:setState()
    self:animate(dt)
    self:untint(dt)
end
--[[
    Function to switch the animations.
]]
function Player:setState()
    if not self.grounded then
        self.state = 'jump'
    elseif self.dx == 0 then
        self.state = 'idle'
    else
        self.state = 'walk'
    end
end
--[[
    Function to apply the animations.
]]
function Player:animate(dt)
    -- Increment the timer.
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end
--[[
    Function to change the direction variable.
]]
function Player:setDirection()
    if self.dx < 0 then
        self.direction = 'left'
    elseif self.dx > 0 then
        self.direction = 'right'
    end
end
--[[
    Function to update the image to draw.
]]
function Player:setNewFrame()
    local anim = self.animation[self.element][self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end
--[[
    Function scan for keyboard input for the movement.
]]
function Player:move(dt)
    -- Right movement.
    if love.keyboard.isDown('right') then
        self.dx = math.min(self.dx + self.accel * dt, self.maxSpeed)
    -- Left movement.
    elseif love.keyboard.isDown('left') then
        self.dx = math.max(self.dx - self.accel * dt, -self.maxSpeed)
    else
        -- Apply Friction to the movement.
        self:applyFriction(dt)
    end
end
-- Dash function.
function Player:dash(key)
    if (key == 'z') and self.element == 'fire' then
        local playdash = false
        if self.dashTime > 0 then
            if self.direction == 'right' then
                self.dx = self.dashSpeed
                self.dy = 0
                self.dashTime = 0
                playdash = true
            elseif self.direction == 'left' then
                self.dx = self.dx -self.maxSpeed * 4
                self.dy = 0
                self.dashTime = 0
                playdash = true
            end
        end
        if playdash then
            self.sfx['dash']:setVolume(0.50)
            self.sfx['dash']:play()
        end
    end
end
--[[
    Function apply the gravity.
]]
function Player:applyGravity(dt)
    if not self.grounded then
        self.dy = self.dy + self.gravity * dt
    end
end
--[[
    Function to apply friction.
]]
function Player:applyFriction(dt)
    -- Apply friction for right movement.
    if self.dx > 0 then
        self.dx = math.max(self.dx - self.friction * dt, 0)
    end
    -- Apply friction for left movement.
    if self.dx < 0 then
        self.dx = math.min(self.dx + self.friction * dt, 0)
    end
end
--[[
    Function to syncronize the physical body with the players position.
]]
function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.dx, self.dy)
end
--[[
    Function to check for collisions.
]]
-- Function to check if a collision start.
function Player:beginContact(a, b, collision)
    if self.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.dy = 0
            Player.sfx['hit']:play()
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.dy = 0
            Player.sfx['hit']:play()
        end
    end
end
-- Function to check items below the player.
function Player:land(collision)
    self.currentGroundCollision = collision
    self.dy                     = 0
    self.grounded               = true
    self.graceTime              = self.graceDuration
    self.dashTime               = self.dashDuration
    self.QuadJump               = 3
end
-- Function to decrease the grace time when the player is not on the grund.
function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end
-- Function to decrease the dash time when the player dashing.
function Player:decreaseDashTime(dt)
    if self.element == 'fire' then
        if not self.grounded then
            self.dashTime = self.dashTime - dt
        end
    end
end
-- Jump function.
function Player:jump(key)
    if key == 'space' then
        local playjump = false
        if self.grounded or self.graceTime > 0 then
            if self.element == 'water' then
                self.dy         = self.jump_Vel * 1.38
                self.grounded   = false
                self.graceTime  = 0
                playjump = true
            else
                self.dy         = self.jump_Vel
                self.grounded   = false
                self.graceTime  = 0
                playjump = true
            end
        elseif self.grounded or self.QuadJump > 0 then
            local jump = -400
            if self.element == 'wind' then
                self.dy         = jump
                self.grounded   = false
                self.graceTime  = 0
                self.QuadJump   = self.QuadJump - 1
                playjump = true
                jump = jump * 0.8
            end
            jump = -400
        end
        if playjump then
            self.sfx['jump']:setVolume(0.50)
            self.sfx['jump']:play()
        end
    end
end
-- Function to change element.
function Player:changeElement(key)
    if key == 'c' then
        local playchange = false
        if self.element == 'mellow' and self.fireCoins then
            self.element = 'fire'
            playchange = true
        elseif self.element == 'fire' and self.waterCoins then
            self.element = 'water'
            playchange = true
        elseif self.element == 'water' and self.windCoins then
            self.element = 'wind'
            playchange = true
        elseif not self.fireCoins and not self.waterCoins and not self.windCoins then
            playchange = false
        else
            self.element = 'mellow'
            playchange = true
        end
        if playchange then
            self.sfx['change']:setVolume(0.50)
            self.sfx['change']:play()
        end
    end
end
-- Shoot function.
function Player:shoot(key)
    if key == 'x' then
        local shooting = false
        -- Shoot flames.
        if self.element == 'fire' then
            if self.direction == 'right' then
                Power.newFlame(self.x + self.width - 25, self.y, 'right')
                self.sfx['flame']:play()
                shooting = true
            elseif self.direction == 'left' then
                Power.newFlame(self.x - 75, self.y, 'left')
                self.sfx['flame']:play()
                shooting = true
            end
        end
        -- Shoot bubbles.
        if self.element == 'water' then
            if self.direction == 'right' then
                Power.newBubble(self.x + self.width - 25, self.y, 'right')
                self.sfx['bubble']:play()
            elseif self.direction == 'left' then
                Power.newBubble(self.x - 75, self.y, 'left')
                self.sfx['bubble']:play()
            end
        end
        -- Shoot breeze.
        if self.element == 'wind' then
            if self.direction == 'right' then
                Power.newBreeze(self.x + self.width - 25, self.y, 'right')
                self.sfx['bubble']:play()
            elseif self.direction == 'left' then
                Power.newBreeze(self.x - 75, self.y, 'left')
                self.sfx['bubble']:play()
            end
        end
        if shooting then
            self.animation.draw = self.animation[self.element].shoot.img[2]
        end
    end
end
-- Function to check if a collision ended.
function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end
--[[
    Function to render the player.
]]
function Player:render()
    -- Divide the position by the size to get the origin centered.
    local scaleX = 1
    if self.direction == 'left' then
        scaleX = -1
    end
    if self.element ~= 'mellow' then
        love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
        love.graphics.draw(self.animation.draw, self.x, self.y,
            0, scaleX, 1, self.animation.width / 2 + 15, self.animation.height / 2 + 10)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
        love.graphics.draw(self.animation.draw, self.x, self.y,
            0, scaleX, 1, self.animation.width / 2, self.animation.height / 2 - 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end
--[[
    Function to load the animations.
]]
function Player:loadAssets()
    -- Set the variables for the animation.
    self.animation       = {timer = 0, rate = 0.5}
    -- Set Mellow animations.
    self.animation.mellow = {}
        -- Walk animation.
        -- Initialize the animation variables.
        self.animation.mellow.walk  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.mellow.walk.total do
            self.animation.mellow.walk.img[i] = love.graphics.newImage('assets/Mellow/walk/'..i..'.png')
        end
        -- Jump animation.
        -- Initialize the animation variables.
        self.animation.mellow.jump  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.mellow.jump.total do
            self.animation.rate = 0.185
            self.animation.mellow.jump.img[i] = love.graphics.newImage('assets/Mellow/jump/'..i..'.png')
        end
        -- Idle animation.
        -- Initialize the animation variables.
        self.animation.mellow.idle  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.mellow.idle.total do
            self.animation.mellow.idle.img[i] = love.graphics.newImage('assets/Mellow/idle/'..i..'.png')
        end
        -- Hit animation.
        -- Initialize the animation variables.
        self.animation.mellow.hit  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.mellow.hit.total do
            self.animation.mellow.hit.img[i] = love.graphics.newImage('assets/Mellow/hit/'..i..'.png')
        end
    -- Set Fire animations
    self.animation.fire = {}
        -- Walk animation.
        -- Initialize the animation variables.
        self.animation.fire.walk  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.fire.walk.total do
            self.animation.fire.walk.img[i] = love.graphics.newImage('assets/Fire/walk/'..i..'.png')
        end
        -- Jump animation.
        -- Initialize the animation variables.
        self.animation.fire.jump  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.fire.jump.total do
            self.animation.rate = 0.185
            self.animation.fire.jump.img[i] = love.graphics.newImage('assets/Fire/jump/'..i..'.png')
        end
        -- Idle animation.
        -- Initialize the animation variables.
        self.animation.fire.shoot  = {total = 2, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.fire.shoot.total do
            self.animation.fire.shoot.img[i] = love.graphics.newImage('assets/Fire/shoot/'..i..'.png')
        end
        -- Idle animation.
        -- Initialize the animation variables.
        self.animation.fire.idle  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.fire.idle.total do
            self.animation.fire.idle.img[i] = love.graphics.newImage('assets/Fire/idle/'..i..'.png')
        end
        -- Hit animation.
        -- Initialize the animation variables.
        self.animation.fire.hit  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.fire.hit.total do
            self.animation.fire.hit.img[i] = love.graphics.newImage('assets/Fire/hit/'..i..'.png')
        end
    -- Set Water animations
    self.animation.water = {}
        -- Walk animation.
        -- Initialize the animation variables.
        self.animation.water.walk  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.water.walk.total do
            self.animation.water.walk.img[i] = love.graphics.newImage('assets/Water/walk/'..i..'.png')
        end
        -- Jump animation.
        -- Initialize the ani.watermation variables.
        self.animation.water.jump  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.water.jump.total do
            self.animation.rate = 0.2
            self.animation.water.jump.img[i] = love.graphics.newImage('assets/Water/jump/'..i..'.png')
        end
        -- Idle animation.
        -- Initialize the animation variables.
        self.animation.water.shoot  = {total = 2, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.water.shoot.total do
            self.animation.water.shoot.img[i] = love.graphics.newImage('assets/Water/shoot/'..i..'.png')
        end
        -- Idle animation.
        -- Initialize the animation variables.
        self.animation.water.idle  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.water.idle.total do
            self.animation.water.idle.img[i] = love.graphics.newImage('assets/Water/idle/'..i..'.png')
        end
        -- Hit animation.
        -- Initialize the animation variables.
        self.animation.water.hit  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.water.hit.total do
            self.animation.water.hit.img[i] = love.graphics.newImage('assets/Water/hit/'..i..'.png')
        end
    -- Set Wind animations
    self.animation.wind = {}
        -- Walk animation.
        -- Initialize the animation variables.
        self.animation.wind.walk  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.wind.walk.total do
            self.animation.wind.walk.img[i] = love.graphics.newImage('assets/Wind/walk/'..i..'.png')
        end
        -- Jump animation.
        -- Initialize the animation variables.
        self.animation.wind.jump  = {total = 4, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.wind.jump.total do
            self.animation.rate = 0.185
            self.animation.wind.jump.img[i] = love.graphics.newImage('assets/Wind/jump/'..i..'.png')
        end
        -- Idle animation.
        -- Initialize the animation variables.
        self.animation.wind.shoot  = {total = 2, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.wind.shoot.total do
            self.animation.wind.shoot.img[i] = love.graphics.newImage('assets/Wind/shoot/'..i..'.png')
        end
        -- Idle animation.
        -- Initialize the animation variables.
        self.animation.wind.idle  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.wind.idle.total do
            self.animation.wind.idle.img[i] = love.graphics.newImage('assets/Wind/idle/'..i..'.png')
        end
        -- Hit animation.
        -- Initialize the animation variables.
        self.animation.wind.hit  = {total = 1, current = 1, img = {}}
        -- Store individual frames.
        for i = 1, self.animation.wind.hit.total do
            self.animation.wind.hit.img[i] = love.graphics.newImage('assets/Wind/hit/'..i..'.png')
        end
    -- Store the current frame to draw.
    self.animation.draw = self.animation.mellow.idle.img[1]
    -- Get the size of the image.
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

return Player
