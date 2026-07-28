local Scene = require("src.ecs.Scene")
local GameSetupSystem = require("src.systems.GameSetupSystem")
local RenderSystem = require("src.systems.RenderSystem")
local PaddleControlSystem = require("src.systems.PaddleControlSystem")
local BallMovementSystem = require("src.systems.BallMovementSystem")
local WallCollisionSystem = require("src.systems.WallCollisionSystem")
local PaddleCollisionSystem = require("src.systems.PaddleCollisionSystem")
local BlockCollisionSystem = require("src.systems.BlockCollisionSystem")

local scene

function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    scene = Scene.new("testLevel")

    -- Sistemas
    scene:addSystem(GameSetupSystem)
    scene:addSystem(RenderSystem)
    scene:addSystem(PaddleControlSystem)
    scene:addSystem(BallMovementSystem)
    scene:addSystem(WallCollisionSystem)
    scene:addSystem(PaddleCollisionSystem)
    scene:addSystem(BlockCollisionSystem)

    scene:setup()

    print("Escena creada: " .. scene.name)
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    scene:draw()
end

function love.quit()
    scene:unload()
end