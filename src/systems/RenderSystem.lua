local RenderSystem = {}

local function drawGame(registry)
    -- Dibuja paddle y bloques
    for entity, position, rectangle, color in
        registry:each(
            "position",
            "rectangle",
            "color"
        )
    do
        love.graphics.setColor(
            color.r,
            color.g,
            color.b
        )

        love.graphics.rectangle(
            "fill",
            position.x,
            position.y,
            rectangle.width,
            rectangle.height
        )

        local outline = registry:get(entity, "outline")

        if outline then
            love.graphics.setLineWidth(outline.width)

            love.graphics.setColor(
                outline.color.r,
                outline.color.g,
                outline.color.b
            )

            love.graphics.rectangle(
                "line",
                position.x,
                position.y,
                rectangle.width,
                rectangle.height
            )
        end
    end

    -- Dibuja la pelota
    for _, position, circle, color in
        registry:each(
            "position",
            "circle",
            "color"
        )
    do
        love.graphics.setColor(
            color.r,
            color.g,
            color.b
        )

        love.graphics.circle(
            "fill",
            position.x,
            position.y,
            circle.radius
        )
    end
end

local function drawEndScreen(registry, message, messageColor)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local _, ui = registry:first("ui")

    if not ui then
        -- Debug
        print("Error: no se encontró UI")
        return
    end

    -- Mensaje principal
    love.graphics.setFont(ui.titleFont)
    love.graphics.setColor(
        messageColor[1],
        messageColor[2],
        messageColor[3]
    )

    love.graphics.printf(
        message,
        0,
        screenHeight / 2 - 100,
        screenWidth,
        "center"
    )

    -- Opciones
    love.graphics.setFont(ui.optionFont)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        "Press 'R' to replay",
        0,
        screenHeight / 2,
        screenWidth,
        "center"
    )

    love.graphics.printf(
        "Press 'Q' to quit",
        0,
        screenHeight / 2 + 50,
        screenWidth,
        "center"
    )
end

function RenderSystem.draw(scene)
    local registry = scene.registry

    love.graphics.clear(0.1, 0.1, 0.15)

    local _, game = registry:first("game")

    if not game then
        -- Debug
        print("Error: no se encontró un juego activo")
        return
    end

    if game.state == "playing" then
        drawGame(registry)

    elseif game.state == "won" then
        drawEndScreen(
            registry,
            "You Win!",
            {0.2, 1, 0.3}
        )

    elseif game.state == "lost" then
        drawEndScreen(
            registry,
            "Game Over",
            {1, 0.2, 0.2}
        )
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end

return RenderSystem