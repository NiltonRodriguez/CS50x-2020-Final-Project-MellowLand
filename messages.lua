--[[
    Contain the functions to display messages.
]]
local Player = require 'Player'
local winner = require 'winner'
local loser  = require 'loser'
-- Function to display the Welcome screen.
function displayWelcome()
    local mellow = love.graphics.newImage('assets/Mellow/walk/2.png')
    love.graphics.draw(mellow,
        WINDOW_WIDTH / 2 - 100, 100, 0, 2, 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(regularFont)
    love.graphics.printf('Welcome to', 0, WINDOW_HEIGHT / 2 - 68, WINDOW_WIDTH, 'center')
    love.graphics.setFont(titleFont)
    love.graphics.printf('MELLOW LAND', 0, WINDOW_HEIGHT / 2 - 32, WINDOW_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.printf('Created by', 0, WINDOW_HEIGHT - 200, WINDOW_WIDTH, 'center')
    love.graphics.printf('Nilton Rodriguez', 0, WINDOW_HEIGHT - 174, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.printf('This is CS50x!', 0, WINDOW_HEIGHT - 148, WINDOW_WIDTH, 'center')
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.printf('2020', 0, WINDOW_HEIGHT - 122, WINDOW_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('(Press ENTER to Start)', 0, WINDOW_HEIGHT - 90, WINDOW_WIDTH, 'center')
end
-- Function to display the score screen.
function displayScore()
    local box    = love.graphics.newImage('assets/Extras/box/box_yel.png')
    local mellow = love.graphics.newImage('assets/Mellow/walk/2.png')
    local fire   = love.graphics.newImage('assets/Extras/coins/coinFire.png')
    local water  = love.graphics.newImage('assets/Extras/coins/coinWater.png')
    local wind   = love.graphics.newImage('assets/Extras/coins/coinWind.png')
    winner:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(titleFont)
    love.graphics.printf('Stage Clear', 0, 50, WINDOW_WIDTH, 'center')
    love.graphics.draw(box, 230, 190, 0, 0.8, 0.8)
    love.graphics.draw(mellow, 780, 180, 0, 1.2, 1.2)
    love.graphics.setFont(titleFont)
    love.graphics.print(' : '..Player.boxes, 320, 200)
    love.graphics.print(' : '..Player.health.current, 900, 200)
    love.graphics.setFont(regularFont)
    love.graphics.printf('Element', 0, 325, WINDOW_WIDTH, 'center')
    if Player.fireCoins then
        love.graphics.draw(fire, WINDOW_WIDTH / 2 - 170, 375, 0, 2, 2)
    end
    if Player.waterCoins then
        love.graphics.draw(water, WINDOW_WIDTH / 2 - 40, 375, 0, 2, 2)
    end
    if Player.windCoins then
        love.graphics.draw(wind, WINDOW_WIDTH / 2 + 90, 375, 0, 2, 2)
    end
end
-- Function to display the Game Over screen.
function displayGameOver()
    loser:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(regularFont)
    love.graphics.printf('Thank you for playing', 0, 150, WINDOW_WIDTH, 'center')
    love.graphics.setFont(titleFont)
    love.graphics.printf('GAME OVER', 0, WINDOW_HEIGHT / 2 + 150, WINDOW_WIDTH, 'center')
end
-- Function to display the Victory screen.
function displayVictory()
    winner.y = WINDOW_HEIGHT / 2 - 100
    winner:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(regularFont)
    love.graphics.printf('Thank you for playing', 0, 150, WINDOW_WIDTH, 'center')
    love.graphics.setFont(titleFont)
    love.graphics.printf('VICTORY!', 0, WINDOW_HEIGHT / 2 + 150, WINDOW_WIDTH, 'center')
end
-- Function to display the FPS.
function displayFPS()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.setFont(smallFont)
    love.graphics.printf("FPS: " .. tostring(love.timer.getFPS()), 0 + 3, WINDOW_HEIGHT - 40 + 3, WINDOW_WIDTH, "center")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(smallFont)
    love.graphics.printf("FPS: " .. tostring(love.timer.getFPS()), 0, WINDOW_HEIGHT - 40, WINDOW_WIDTH, "center")
end
