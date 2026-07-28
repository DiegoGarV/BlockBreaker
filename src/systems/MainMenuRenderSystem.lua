local MainMenuRenderSystem = {}

local function drawTitle(registry)
    local _, menu = registry:first("menu")
    local _, ui = registry:first("ui")

    if not menu or not ui then
        -- Debug
        print("Error: no se encontró la información del menú")
        return
    end

    local screenWidth = love.graphics.getWidth()

    love.graphics.setFont(ui.titleFont)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        menu.title,
        0,
        80,
        screenWidth,
        "center"
    )
end

local function drawButtons(registry)
    local _, ui = registry:first("ui")

    if not ui then
        -- Debug
        print("Error: no se encontró la UI del menú")
        return
    end

    -- Dibuja los botones
    for entity, position, rectangle, color, button in
        registry:each(
            "position",
            "rectangle",
            "color",
            "button"
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
            rectangle.height,
            8,
            8
        )

        local outline =
            registry:get(entity, "outline")

        if outline then
            love.graphics.setLineWidth(
                outline.width
            )

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
                rectangle.height,
                8,
                8
            )
        end

        love.graphics.setFont(ui.buttonFont)
        love.graphics.setColor(1, 1, 1)

        local fontHeight =
            ui.buttonFont:getHeight()

        local textY =
            position.y +
            rectangle.height / 2 -
            fontHeight / 2

        love.graphics.printf(
            button.text,
            position.x,
            textY,
            rectangle.width,
            "center"
        )
    end
end

function MainMenuRenderSystem.draw(scene)
    local registry = scene.registry

    love.graphics.clear(0.1, 0.1, 0.15)

    drawTitle(registry)
    drawButtons(registry)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end

return MainMenuRenderSystem