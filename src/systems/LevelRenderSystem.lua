local LevelRenderSystem = {}

local function drawGame(registry)
    -- Dibuja paddle y bloques
    for entity, _, position, rectangle, color in
        registry:each(
            "levelEntity",
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
    for _, _, position, circle, color in
        registry:each(
            "levelEntity",
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

function LevelRenderSystem.draw(scene)
    love.graphics.clear(
        0.1,
        0.1,
        0.15
    )

    drawGame(scene.registry)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end

return LevelRenderSystem