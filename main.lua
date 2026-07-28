local Scene = require("src.ecs.Scene")
local GameSetupSystem = require("src.systems.GameSetupSystem")
local RenderSystem = require("src.systems.RenderSystem")
local PaddleControlSystem = require("src.systems.PaddleControlSystem")

local scene

function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    scene = Scene.new("testLevel")

    -- Sistemas
    scene:addSystem(GameSetupSystem)
    scene:addSystem(RenderSystem)
    scene:addSystem(PaddleControlSystem)

    scene:setup()

    print("Escena creada: " .. scene.name)

    -- Pruebas del GameSetupSystem
    local paddleEntities = scene.registry:query("paddle")
    local ballEntities = scene.registry:query("ball")
    local blockEntities = scene.registry:query("block")
    local gameEntity, game = scene.registry:first("game")

    print("Paddles creados: " .. #paddleEntities)
    print("Pelotas creadas: " .. #ballEntities)
    print("Bloques creados: " .. #blockEntities)
    print("Estado del juego: " .. game.state)
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