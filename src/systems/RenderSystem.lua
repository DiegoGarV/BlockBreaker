local RenderSystem = {}

function RenderSystem.draw(scene)
    local registry = scene.registry

    -- Fondo
    love.graphics.clear(0.1, 0.1, 0.15)

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

    -- Restaurar valores
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end

return RenderSystem