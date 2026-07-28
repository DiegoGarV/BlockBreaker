local Scene = require("src.ecs.Scene")
local GameSetupSystem = require("src.systems.GameSetupSystem")
local InputSystem = require("src.systems.InputSystem")
local PaddleControlSystem = require("src.systems.PaddleControlSystem")
local BallMovementSystem = require("src.systems.BallMovementSystem")
local WallCollisionSystem = require("src.systems.WallCollisionSystem")
local PaddleCollisionSystem = require("src.systems.PaddleCollisionSystem")
local BlockCollisionSystem = require("src.systems.BlockCollisionSystem")
local GameStateSystem = require("src.systems.GameStateSystem")
local LevelRenderSystem = require("src.systems.LevelRenderSystem")

local LevelScene = {}

function LevelScene.new()
    local scene = Scene.new("TestLevel")

    -- Sistemas
    scene:addSystem(GameSetupSystem)
    scene:addSystem(InputSystem)
    scene:addSystem(PaddleControlSystem)
    scene:addSystem(BallMovementSystem)
    scene:addSystem(WallCollisionSystem)
    scene:addSystem(PaddleCollisionSystem)
    scene:addSystem(BlockCollisionSystem)
    scene:addSystem(GameStateSystem)
    scene:addSystem(LevelRenderSystem)

    return scene
end

return LevelScene