local GameSetupSystem = {}

local function createPaddle(registry)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local paddleWidth = 120
    local paddleHeight = 20

    return registry:spawn({
        position = {
            x = screenWidth / 2 - paddleWidth / 2,
            y = screenHeight - 60
        },

        rectangle = {
            width = paddleWidth,
            height = paddleHeight
        },

        color = {
            r = 1,
            g = 1,
            b = 1
        },

        paddle = {
            speed = 400
        }
    })
end

local function createBall(registry)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    return registry:spawn({
        position = {
            x = screenWidth / 2,
            y = screenHeight - 80
        },

        velocity = {
            x = 0,
            y = 200
        },

        circle = {
            radius = 10
        },

        color = {
            r = 1,
            g = 0.3,
            b = 0.3
        },

        ball = {
            speedIncrease = 1.10,
            maxSpeed = 700
        }
    })
end

local function createBlock(
    registry,
    x,
    y,
    width,
    height,
    color
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
            r = color[1],
            g = color[2],
            b = color[3]
        },

        outline = {
            width = 2,
            color = {
                r = 0,
                g = 0,
                b = 0
            }
        },

        block = {}
    })
end

local function createBlockGrid(
    registry,
    rows,
    columns,
    colors,
    margins
)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    margins = margins or {}

    local left = margins.left or 0
    local right = margins.right or 0
    local top = margins.top or 0
    local bottom = margins.bottom or 0

    local gridAreaHeight = screenHeight * (7 / 12)

    local availableWidth =
        screenWidth - left - right

    local availableHeight =
        gridAreaHeight - top - bottom

    local blockWidth =
        availableWidth / columns

    local blockHeight =
        availableHeight / rows

    for row = 1, rows do
        local colorIndex =
            ((row - 1) % #colors) + 1

        local rowColor = colors[colorIndex]

        for column = 1, columns do
            local blockX =
                left + (column - 1) * blockWidth

            local blockY =
                top + (row - 1) * blockHeight

            createBlock(
                registry,
                blockX,
                blockY,
                blockWidth,
                blockHeight,
                rowColor
            )
        end
    end
end

function GameSetupSystem.reset(scene)
    local registry = scene.registry

    -- Elimina todas las entidades registradas
    for _, entity in ipairs(
        registry:query("position")
    ) do
        registry:destroy(entity)
    end

    -- Elimina la entidad global del juego
    for _, entity in ipairs(
        registry:query("game")
    ) do
        registry:destroy(entity)
    end

    -- Eliminar posibles eventos de derrota
    for _, entity in ipairs(
        registry:query("loseRequest")
    ) do
        registry:destroy(entity)
    end

    -- Eliminar eventos de teclado
    for _, entity in ipairs(
        registry:query("keyPressed")
    ) do
        registry:destroy(entity)
    end

    registry:spawn({
        game = {
            state = "playing"
        }
    })

    createPaddle(registry)
    createBall(registry)

    local blockColors = {
        {1, 0.2, 0.2},
        {0.2, 1, 0.2},
        {0.2, 0.4, 1},
        {1, 0.8, 0.2}
    }

    createBlockGrid(
        registry,
        6,
        8,
        blockColors,
        {
            top = 40,
            left = 40,
            right = 40
        }
    )
end

function GameSetupSystem.setup(scene)
    local registry = scene.registry

    registry:spawn({
        ui = {
            titleFont = love.graphics.newFont(48),
            optionFont = love.graphics.newFont(24)
        }
    })

    GameSetupSystem.reset(scene)

    -- Debug
    print("GameSetupSystem ejecutado")
end

return GameSetupSystem