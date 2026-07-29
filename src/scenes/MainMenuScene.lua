local Scene = require("src.ecs.Scene")
local MainMenuSetupSystem = require("src.systems.MainMenuSetupSystem")
local InputSystem = require("src.systems.InputSystem")
local MainMenuRenderSystem = require("src.systems.MainMenuRenderSystem")
local UISystem = require("src.systems.UISystem")

local MainMenuScene = {}

function MainMenuScene.new()
    local scene = Scene.new("mainMenu")

    scene:addSystem(MainMenuSetupSystem)
    scene:addSystem(InputSystem)
    scene:addSystem(MainMenuRenderSystem)
    scene:addSystem(UISystem)

    return scene
end

return MainMenuScene