local Canvas = require("src.ui.Canvas")

local MainMenuSetupSystem = {}

function MainMenuSetupSystem.setup(scene)
    local registry = scene.registry

    local screenWidth = love.graphics.getWidth()

    local buttonWidth = 240
    local buttonHeight = 60
    local spacing = 20

    local startX =
        screenWidth / 2 -
        buttonWidth / 2

    local startY = 250

    Canvas.create(registry, {
        id = "mainMenu",
        active = true,
        interactive = true,
        navigation = "vertical",
        selectedIndex = 1
    })

    Canvas.createText(registry, {
        id = "mainMenuTitle",
        canvasId = "mainMenu",
        value = "Block Breacker",
        font = "title",
        x = 0,
        y = 80,
        width = screenWidth,
        align = "center"
    })

    Canvas.createButton(registry, {
        canvasId = "mainMenu",
        text = "Play",
        action = "play",
        index = 1,
        active = true,
        x = startX,
        y = startY,
        width = buttonWidth,
        height = buttonHeight
    })

    Canvas.createButton(registry, {
        canvasId = "mainMenu",
        text = "Levels",
        action = "levels",
        index = 2,
        active = false,
        x = startX,
        y = startY +
            buttonHeight +
            spacing,
        width = buttonWidth,
        height = buttonHeight
    })

    Canvas.createButton(registry, {
        canvasId = "mainMenu",
        text = "Quit",
        action = "quit",
        index = 3,
        active = true,
        x = startX,
        y = startY +
            (buttonHeight + spacing) * 2,
        width = buttonWidth,
        height = buttonHeight
    })
end

return MainMenuSetupSystem