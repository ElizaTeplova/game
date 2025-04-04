function love.load()
    math.randomseed(os.time())
    -- region Import
    anim8 = require 'anim8/anim8' -- animatons
    love.graphics.setDefaultFilter('nearest', 'nearest')
    sti = require 'Simple-Tiled-Implementation/sti' -- map generation
    camera = require 'hump/camera' -- camera chasing player
    wf = require 'windfield/windfield'
    Player = require 'Player'
    Camera = require 'Camera'
    Flower = require 'Flower'
    -- endregion
    -- region init world, player, camera, flower
    world = wf.newWorld(0, 0)
    world:addCollisionClass('Player')
    world:addCollisionClass('Flower')
    world:addCollisionClass('Wall')

    cam = camera()
    gameMap = sti('resources/maps/map.lua')


    player = Player.new(400, 200, world, gameMap)
    player:loadAnimation()
    player:setCollider()
    camera = Camera.new(cam, player, gameMap)
    flower = Flower.new(world, gameMap)
    flower:setCollider()
    -- endregion
    -- region Add Walls to the Map
    --background = love.graphics.newImage('resources/sprites/background.png')
    walls = {}
    if gameMap.layers['Walls'] then
        for i, obj in pairs(gameMap.layers['Walls'].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setCollisionClass('Wall')
            wall:setType('static')
            wall:setObject(wall)
            table.insert(walls, wall)
        end
    end
    -- endregion
    -- region Set Up Infinite Music
    sounds = {}
    sounds.relaxBackgroundMusic = love.audio.newSource('resources/sounds/relaxed-scene.mp3', 'stream')
    sounds.relaxBackgroundMusic:setLooping(true)
    sounds.relaxBackgroundMusic:play()
    -- endregion
end

function love.update(dt)
    player:update(dt)
    flower:update()
    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    player.anim:update(dt)
    camera:update(dt)
end

function love.draw()
    cam:attach()
        -- gameMap:draw()
        gameMap:drawLayer(gameMap.layers['Ground'])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
        flower:draw()
        gameMap:drawLayer(gameMap.layers['Trees'])
        --world:draw() -- if you wanna see colliders in the world
        love.graphics.setColor(1, 0, 0)
        love.graphics.print('R - reset flower position', cam.x + 250, cam.y - 250)
        love.graphics.print('Player: ' .. math.floor(player.x) .. ';' .. math.floor(player.y), cam.x + 250, cam.y - 200)
        love.graphics.print('Flower: ' .. flower.x .. ';' .. flower.y, cam.x + 250, cam.y - 150)
        love.graphics.setColor(1, 1, 1)
    cam:detach()
end

function love.keypressed(key)
    if key == 'r' then
        flower:changePlace()
    end
end