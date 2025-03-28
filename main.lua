function love.load()
    anim8 = require 'anim8/anim8' -- animatons
    love.graphics.setDefaultFilter('nearest', 'nearest')
    sti = require 'Simple-Tiled-Implementation/sti' -- map generation
    camera = require 'hump/camera' -- camera chasing player
    wf = require 'windfield/windfield'
    Player = require 'Player'

    world = wf.newWorld(0, 0)
    player = Player.new(400, 200, world)
    player:loadAnimation()
    player:setCollider()

    cam = camera()

    gameMap = sti('resources/maps/map.lua')

    --background = love.graphics.newImage('resources/sprites/background.png')
    walls = {}
    if gameMap.layers['Walls'] then
        for i, obj in pairs(gameMap.layers['Walls'].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end

    sounds = {}
    sounds.relaxBackgroundMusic = love.audio.newSource('resources/sounds/relaxed-scene.mp3', 'stream')
    sounds.relaxBackgroundMusic:setLooping(true)
    sounds.relaxBackgroundMusic:play()
end

function love.update(dt)
    player:update(dt)
    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Left border
    if cam.x < w / 2 then cam.x = w / 2 end
    -- Top border
    if cam.y < h / 2 then cam.y = h / 2 end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if cam.x > (mapW - w / 2) then cam.x = mapW - w / 2 end
    -- Bottom border
    if cam.y > (mapH - h / 2) then cam.y = mapH - h / 2 end
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
    --world:draw() -- if you wanna see colliders in the world
    cam:detach()
end