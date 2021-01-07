--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
-- Call libraries.
require 'messages'
local Box = require 'box'
local Camera = require 'camera'
local Cloud = require 'cloud'
local Coin = require 'coin'
local Enemy = require 'enemy'
local Flag = require 'flag'
local GUI = require 'gui'
local loser = require 'loser'
local Map = require 'map'
local Player = require 'Player'
local Power = require 'power'
local winner = require 'winner'
-- Initialize Constants
-- Window size.
WINDOW_WIDTH    = 1280
WINDOW_HEIGHT   = 720
--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    math.randomseed(os.time())
    -- Set the title of out application window.
    love.window.setTitle('Mellow Land')
    -- Load the game fonts.
    titleFont   = love.graphics.newFont('font.ttf', 64)
    regularFont = love.graphics.newFont('font.ttf', 32)
    mediumFont  = love.graphics.newFont('font.ttf', 24)
    smallFont   = love.graphics.newFont('font.ttf', 16)
    -- Initialize the window.
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen  = false,
        vsync       = true,
        resizable   = false,
        centered    = true
    })
    -- Set the game state.
    gameState = 'welcome'
    -- Initialize the enemy.
    Enemy.init()
    -- Initialize the map.
    Map:load()
    -- initialize the GUI
    GUI:init()
    -- Initialize the player.
    Player:init()
    winner:init()
    loser:init()
    -- Initialize the powers.
    Power:loadAssets()
    -- Initialize the music.
    music = {
        ['stage']    = love.audio.newSource('sfx/jazzy-duck.wav', 'static'),
        ['welcome']  = love.audio.newSource('sfx/ocean-floor.wav', 'static'),
        ['victory']  = love.audio.newSource('sfx/Catchy_Comedy_Jazz.mp3', 'static'),
        ['final']    = love.audio.newSource('sfx/Dawn_Forest_Healing.mp3', 'static')
    }
end
--[[
    Runs every frame, with "dt" passed in, our delta in seconds
    since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Camera:setPosition(Player.x, MapHeight / 2)
    Coin.updateAll(dt)
    Box.updateAll(dt)
    Enemy.updateAll(dt)
    winner:update(dt)
    loser:update(dt)
    Power.updateAll(dt)
    -- Update the music on each game state.
    if gameState == 'welcome' then
        -- Play the music.
        music['welcome']:setLooping(true)
        music['welcome']:setVolume(0.50)
        music['welcome']:play()
    elseif gameState == 'intro' then
        -- Stop the welcome music.
        music['welcome']:stop()
        -- Play the stage music.
        music['stage']:setLooping(true)
        music['stage']:setVolume(0.25)
        music['stage']:play()
    elseif gameState == 'stage1' or gameState == 'stage2' or gameState == 'stage3' then
        -- Stop the victory music.
        music['victory']:stop()
        -- Play the stage music.
        music['stage']:setLooping(true)
        music['stage']:setVolume(0.25)
        music['stage']:play()
    elseif gameState == 'game_over' then
        -- Stop all the sounds.
        music['stage']:stop()
        music['victory']:stop()
        Player.sfx['hit']:stop()
        Player.sfx['jump']:stop()
        -- Play the game over music.
        music['final']:setLooping(true)
        music['final']:play()
    end
end
--[[
    Scan keys.
]]
-- Called whenever a key is pressed.
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'welcome' then
            gameState = 'intro'
        elseif gameState == 'scorei' then
            gameState = 'stage1'
            Map:next()
        elseif gameState == 'score1' then
            gameState = 'stage2'
            Map:next()
        elseif gameState == 'score2' then
            gameState = 'stage3'
            Map:next()
        elseif gameState == 'score3' then
            gameState = 'victory'
        end
    elseif key == 'space' then
        Player:jump(key)
    elseif key == 'c' then
        Player:changeElement(key)
    elseif key == 'z' then
        Player:dash(key)
    elseif key == 'x' then
        Player:shoot(key)
    end
end
-- Callen whenever a key is released.
function love.keyreleased(key)
    if key == 'x' and Player.element ~= 'mellow' then
        Player.animation.draw = Player.animation[Player.element].shoot.img[1]
    end
end
--[[
    Called after update by LÖVE2D, used to draw anything to the screen,
    updated or otherwise.
]]
function love.draw()
    if gameState == 'welcome' then
        -- Display the welcome screen.
        displayWelcome()
    elseif gameState == 'intro' then
        -- Set the background color.
        love.graphics.clear(0, 199 / 255, 1, 1)
        -- Sync the camera movement with the elements of the map.
        Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
        -- Render the map, entities, player and GUI
        RenderMap()
    elseif gameState == 'stage1' then
        -- Set the background color.
        love.graphics.clear(142 / 255, 54 / 255, 0, 1)
        -- Sync the camera movement with the elements of the map.
        Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
        -- Render the map, entities, player and GUI
        RenderMap()
    elseif gameState == 'stage2' then
        -- Set the background color.
        love.graphics.clear(1, 117 / 255, 137 / 255, 1)
        -- Sync the camera movement with the elements of the map.
        Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
        -- Render the map, entities, player and GUI
        Flag.y = 250
        RenderMap()
    elseif gameState == 'stage3' then
        -- Set the background color.
        love.graphics.clear(0 / 255, 76 / 255, 96 / 255, 1)
        -- Sync the camera movement with the elements of the map.
        Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
        -- Render the map, entities, player and GUI
        RenderMap()
    elseif gameState == 'scorei' or gameState == 'score1' or
        gameState == 'score2' or gameState == 'score3'then
        -- Display the score screen
        displayScore()
    elseif gameState == 'game_over' then
        -- Display the Game Over screen
        displayGameOver()
    elseif gameState == 'victory' then
        -- Display the victory screen
        displayVictory()
    end
    -- Display the current Frames per second.
    displayFPS()
end
--[[
    Functions to check for collisions.
]]
-- Function to check if a collision start.
function beginContact(a, b, collision)
    Enemy.beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    if Power.beginContact(a, b, collision) then return end
    Box.beginContact(a, b, collision)
    Cloud.beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
    if Flag.beginContact(a, b, collision) then return end
end
-- Function to check if a collision ended.
function endContact(a, b, collision)
    Player:endContact(a, b, collision)
    Enemy:endContact(a, b, collision)
end
--[[
    Functions to load all the render functions.
]]
function RenderMap()
    -- Apply the graphic scales.
    love.graphics.push()
    -- Apply the camera movements.
    Camera:apply()
    -- Render the player, coins, boxes and clouds.
    Player:render()
    Coin.renderAll()
    Box.renderAll()
    Cloud.renderAll()
    Enemy.renderAll()
    Power.renderAll()
    Flag.renderAll()
    -- End the graphic scales.
    love.graphics.pop()
    -- Render the GUI.
    GUI:render()
end
