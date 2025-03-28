---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by nikita.
--- DateTime: 28.03.2025 14:17
---

local mt = {}
mt.__index = mt

function mt:setCollider()
    self.collider = world:newBSGRectangleCollider(400, 250, 50, 100, 10)
    self.collider:setCollisionClass('Flower')
    self.collider:setType('static')
    self.collider:setFixedRotation(true)
    self.collider:setObject(self)
    self:initializeSprites()
    self:initializeSounds()
end

function mt:initializeSprites()
    local flowers = love.filesystem.getDirectoryItems('resources/sprites/flower')
    self.flowers = {}
    for _, img in ipairs(flowers) do
        self.flowers[#self.flowers + 1] = love.graphics.newImage('resources/sprites/flower/' .. img)
    end
end

function mt:initializeSounds()
    local sounds = love.filesystem.getDirectoryItems('resources/sounds/catch-flower')
    self.sounds = {}
    self.curSound = 1
    for _, sound in ipairs(sounds) do
        self.sounds[#self.sounds + 1] = love.audio.newSource('resources/sounds/catch-flower/' .. sound, 'static')
    end
end

function mt:update()
    if self.collider:enter('Player') or self.collider:enter('Wall') then
        self:changePlace()
    end

    flower.x = flower.collider:getX()
    flower.y = flower.collider:getY()
end

function mt:changePlace()
    repeat
        local mapW = self.gameMap.width * self.gameMap.tilewidth - 50
        local mapH = self.gameMap.height * self.gameMap.tileheight - 50
        local x = math.random(0, mapW)
        local y = math.random(0, mapH)
        self.collider:setPosition(x, y)
        walls = world:queryCircleArea(x, y, 50, { 'Player', 'Wall'})
    until next(walls) == nil
    self.sounds[self.curSound]:play()
    --self.curSound = ((self.curSound + 1) % #self.sounds) + 1
    self.curSound = math.random(1, #self.sounds)
    --self.curFlower = ((self.curFlower + 1) % #self.flowers) + 1
    self.curFlower = math.random(1, #self.flowers)
end

function mt:draw()
    love.graphics.draw(self.flowers[self.curFlower], self.x, self.y, nil, 4, nil, 15, 15)
end

function mt:load()

end

return {
    new = function(world, gameMap)
        return setmetatable({
            world = world,
            gameMap = gameMap,
            x = 200, y = 150,
            flowerSprite = nil,
            curFlower = 3,
            flowers = {},
            curSound = 1,
            sounds = {}
        }, mt)
    end
}