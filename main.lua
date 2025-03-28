function love.load()
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
            wall:setType('static')
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
    --love.graphics.circle("fill", player.x, player.y, 100)
    --love.graphics.draw(player.sprite, player.x, player.y)
    --love.graphics.draw(background, 0, 0)
    cam:attach()
        -- gameMap:draw()
        gameMap:drawLayer(gameMap.layers['Ground'])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
        gameMap:drawLayer(gameMap.layers['Trees'])
        flower:draw()
        world:draw() -- if you wanna see colliders in the world
    cam:detach()
end