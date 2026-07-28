local Scene = require("src.ecs.Scene")
local MainMenuSetupSystem = require("src.systems.MainMenuSetupSystem")
local MainMenuRenderSystem = require("src.systems.MainMenuRenderSystem")

local MainMenuScene = {}

function MainMenuScene.new()
    local scene = Scene.new("mainMenu")

    scene:addSystem(MainMenuSetupSystem)
    scene:addSystem(MainMenuRenderSystem)

    return scene
end

return MainMenuScene