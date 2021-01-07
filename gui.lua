--[[
    Contains the GUI information.
]]
local GUI    = {}
local Player = require 'Player'
--[[
    Initialize the GUI information.
]]
function GUI:init()
    -- Set the fire coins variables.
    self.ficoins        = {}
    self.ficoins.img    = love.graphics.newImage('assets/Extras/coins/coinFire.png')
    self.ficoins.width  = self.ficoins.img:getWidth()
    self.ficoins.height = self.ficoins.img:getHeight()
    self.ficoins.scale  = 1.2
    self.ficoins.x      = 10
    self.ficoins.y      = WINDOW_HEIGHT - 50
    -- Set the water coins variables.
    self.wacoins        = {}
    self.wacoins.img    = love.graphics.newImage('assets/Extras/coins/coinWater.png')
    self.wacoins.width  = self.wacoins.img:getWidth()
    self.wacoins.height = self.wacoins.img:getHeight()
    self.wacoins.scale  = 1.2
    self.wacoins.x      = 60
    self.wacoins.y      = WINDOW_HEIGHT - 50
    -- Set the wind coins variables.
    self.wicoins        = {}
    self.wicoins.img    = love.graphics.newImage('assets/Extras/coins/coinWind.png')
    self.wicoins.width  = self.wicoins.img:getWidth()
    self.wicoins.height = self.wicoins.img:getHeight()
    self.wicoins.scale  = 1.2
    self.wicoins.x      = 110
    self.wicoins.y      = WINDOW_HEIGHT - 50
    -- Set the box variables.
    self.totalbox        = {}
    self.totalbox.img    = love.graphics.newImage('assets/Extras/box/box_yel.png')
    self.totalbox.width  = self.totalbox.img:getWidth()
    self.totalbox.height = self.totalbox.img:getHeight()
    self.totalbox.x      = WINDOW_WIDTH - 180
    self.totalbox.y      = 10
    -- set the life variable.
    self.lives         = {}
    self.lives.img     = love.graphics.newImage('assets/Mellow/idle/1.png')
    self.lives.width   = self.lives.img:getWidth()
    self.lives.height  = self.lives.img:getHeight()
    self.lives.x       = 0
    self.lives.y       = 10
    self.lives.scale   = 0.5
    self.lives.spacing = self.lives.width * self.lives.scale + 10
    -- Set the font.
    self.font = mediumFont

end
--[[
    Render the GUI information.
]]
function GUI:render()
    self:displayficoins()
    self:displaywacoins()
    self:displaywicoins()
    self:displaytotalbox()
    self:displayboxtext()
    self:displayLives()
    self:displayStage()
end
--[[
    Display functions
]]
-- Function to display the lives.
function GUI:displayLives()
    for i = 1, Player.health.current do
        local x = self.lives.x + self.lives.spacing * i
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.lives.img, x + 3, self.lives.y + 3, 0,
            self.lives.scale, self.lives.scale)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.lives.img, x, self.lives.y, 0,
            self.lives.scale, self.lives.scale)
        love.graphics.setFont(self.font)
    end
end
-- Function to display the fire coin.
function GUI:displayficoins()
    if Player.fireCoins then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.ficoins.img, self.ficoins.x + 3, self.ficoins.y + 3, 0,
            self.ficoins.scale, self.ficoins.scale)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.ficoins.img, self.ficoins.x, self.ficoins.y, 0,
            self.ficoins.scale, self.ficoins.scale)
    end
end
-- Function to display the water coin.
function GUI:displaywacoins()
    if Player.waterCoins then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.wacoins.img, self.wacoins.x + 3, self.wacoins.y + 3, 0,
            self.wacoins.scale, self.wacoins.scale)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.wacoins.img, self.wacoins.x, self.wacoins.y, 0,
            self.wacoins.scale, self.wacoins.scale)
    end
end
-- Function to display the wind coin.
function GUI:displaywicoins()
    if Player.windCoins then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.wicoins.img, self.wicoins.x + 3, self.wicoins.y + 3, 0,
            self.wicoins.scale, self.wicoins.scale)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.wicoins.img, self.wicoins.x, self.wicoins.y, 0,
            self.wicoins.scale, self.wicoins.scale)
    end
end
-- Function to display the box.
function GUI:displaytotalbox()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.totalbox.img, self.totalbox.x + 3, self.totalbox.y + 3, 0, 0.5, 0.5)
    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.totalbox.img, self.totalbox.x, self.totalbox.y, 0, 0.5, 0.5)
    love.graphics.setFont(self.font)
end
-- Function to display the box amount.
function GUI:displayboxtext()
    local x = self.totalbox.x + self.totalbox.width * 0.5
    local y = self.totalbox.y + self.totalbox.height / 2 * 0.5 - self.font:getHeight() / 2
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(' : '..Player.boxes, x + 3, y + 3)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(' : '..Player.boxes, x, y)
end
-- Function to display the stage
function GUI:displayStage()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf(gameState, 0 + 3, 25 + 3, WINDOW_WIDTH, "center")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(mediumFont)
    love.graphics.printf(gameState, 0, 25, WINDOW_WIDTH, "center")
end

return GUI
