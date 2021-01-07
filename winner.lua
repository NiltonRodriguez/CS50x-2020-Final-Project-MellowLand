--[[
    Contains the winner animation.
]]
local winner = {}
--[[
    Function to initialize the winner.
]]
function winner:init()
    -- Set winner position.
    self.x = WINDOW_WIDTH / 2 - 100
    self.y = WINDOW_HEIGHT - 225
    -- Set the winner size.
    self.width = 100
    self.height = 100
    -- Set the animations.
    self:loadAssets()
end
--[[
    Function to load the animations.
]]
function winner:loadAssets()
    -- Set the variables for the animation.
    self.animation = {timer = 0, rate = 0.5}
    -- Initialize the animation variables.
    self.animation.victory = {total = 2, current = 1, img = {}}
    -- Store individual frames.
    for i = 1, self.animation.victory.total do
        self.animation.victory.img[i] = love.graphics.newImage('assets/Mellow/victory/'..i..'.png')
    end
    -- Store the current frame to draw.
    self.animation.draw = self.animation.victory.img[1]
end
--[[
    Function to update the player.
]]
function winner:update(dt)
    self:animate(dt)
end
--[[
    Function to apply the animations.
]]
function winner:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end
--[[
    Function to update the image to draw.
]]
function winner:setNewFrame()
    local anim = self.animation.victory
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end
--[[
    Function to render the winner.
]]
function winner:render()
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, 2, 2)
end

return winner
