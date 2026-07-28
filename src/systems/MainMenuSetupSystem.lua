local MainMenuSetupSystem = {}

local function createButton(
    registry,
    text,
    x,
    y,
    width,
    height
)
    return registry:spawn({
        position = {
            x = x,
            y = y
        },

        rectangle = {
            width = width,
            height = height
        },

        color = {
            r = 0.2,
            g = 0.4,
            b = 0.8
        },

        outline = {
            width = 2,
            color = {
                r = 1,
                g = 1,
                b = 1
            }
        },

        button = {
            text = text
        }
    })
end

function MainMenuSetupSystem.setup(scene)
    local registry = scene.registry

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local buttonWidth = 240
    local buttonHeight = 60
    local buttonSpacing = 20

    local totalButtonsHeight =
        buttonHeight * 3 +
        buttonSpacing * 2

    local startX =
        screenWidth / 2 -
        buttonWidth / 2

    local startY =
        screenHeight / 2 -
        totalButtonsHeight / 2 +
        60

    registry:spawn({
        menu = {
            title = "Block Breacker"
        },

        ui = {
            titleFont = love.graphics.newFont(52),
            buttonFont = love.graphics.newFont(24)
        }
    })

    createButton(
        registry,
        "Play",
        startX,
        startY,
        buttonWidth,
        buttonHeight
    )

    createButton(
        registry,
        "Levels",
        startX,
        startY + buttonHeight + buttonSpacing,
        buttonWidth,
        buttonHeight
    )

    createButton(
        registry,
        "Quit",
        startX,
        startY +
            (buttonHeight + buttonSpacing) * 2,
        buttonWidth,
        buttonHeight
    )

    print("Main Menu ejecutado")
end

return MainMenuSetupSystem