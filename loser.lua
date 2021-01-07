--[[
    Contains the loser animation.
]]
local loser = {}
--[[
    Function to initualize the loser.
]]
function loser:init()
    -- Set loser position.
    self.x = WINDOW_WIDTH / 2 - 100
    self.y = WINDOW_HEIGHT / 2 - 100
    -- Set the loser size.
    self.width  = 100
    self.height = 100
    -- Set the animations.
    self:loadAssets()
end
--[[
    Function to load the animations.
]]
function loser:loadAssets()
    -- Set the variables for the animation.
    self.animation = {timer = 0, rate = 0.3}
    -- Initialize the animation variables.
    self.animation.die = {total = 4, current = 1, img = {}}
    -- Store individual frames.
    for i = 1, self.animation.die.total do
        self.animation.die.img[i] = love.graphics.newImage('assets/Mellow/die/'..i..'.png')
    end
    -- Store the current frame to draw.
    self.animation.draw = self.animation.die.img[1]
end
--[[
    Function to update the player.
]]
function loser:update(dt)
    self:animate(dt)
end
--[[
    Function to apply the animations.
]]
function loser:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end
--[[
    Function to update the image to draw.
]]
function loser:setNewFrame()
    local anim = self.animation.die
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end
--[[
    Function to render the player.
]]
function loser:render()
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, 2, 2)
end

return loser
