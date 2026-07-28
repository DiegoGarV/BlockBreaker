local Scene = require("src.ecs.Scene")
local GameSetupSystem = require("src.systems.GameSetupSystem")
local InputSystem = require("src.systems.InputSystem")
local PaddleControlSystem = require("src.systems.PaddleControlSystem")
local BallMovementSystem = require("src.systems.BallMovementSystem")
local WallCollisionSystem = require("src.systems.WallCollisionSystem")
local PaddleCollisionSystem = require("src.systems.PaddleCollisionSystem")
local BlockCollisionSystem = require("src.systems.BlockCollisionSystem")
local GameStateSystem = require("src.systems.GameStateSystem")
local RenderSystem = require("src.systems.RenderSystem")

local scene

function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    scene = Scene.new("testLevel")

    -- Sistemas
    scene:addSystem(GameSetupSystem)
    scene:addSystem(InputSystem)
    scene:addSystem(PaddleControlSystem)
    scene:addSystem(BallMovementSystem)
    scene:addSystem(WallCollisionSystem)
    scene:addSystem(PaddleCollisionSystem)
    scene:addSystem(BlockCollisionSystem)
    scene:addSystem(GameStateSystem)
    scene:addSystem(RenderSystem)

    scene:setup()

    print("Escena creada: " .. scene.name)
end

function love.update(dt)
    scene:update(dt)
end

function love.keypressed(key)
    scene.registry:spawn({keyPressed = {key = key}})
end

function love.draw()
    scene:draw()
end

function love.quit()
    scene:unload()
end