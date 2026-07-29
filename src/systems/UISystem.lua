local Canvas = require("src.ui.Canvas")

local UISystem = {}

function UISystem.setup(scene)
    local registry = scene.registry

    local _, resources = registry:first("uiResources")

    if resources then
        return
    end

    registry:spawn({
        uiResources = {
            fonts = {
                title = love.graphics.newFont(48),
                normal = love.graphics.newFont(24),
                button = love.graphics.newFont(24)
            }
        }
    })
end

local function drawCanvasBackgrounds(registry)
    local screenWidth = love.graphics.getWidth()

    local screenHeight = love.graphics.getHeight()

    for _, canvas in
        registry:each("canvas")
    do
        if canvas.active and canvas.dim > 0 then
            love.graphics.setColor(
                0,
                0,
                0,
                canvas.dim
            )

            love.graphics.rectangle(
                "fill",
                0,
                0,
                screenWidth,
                screenHeight
            )
        end
    end
end

local function drawTexts(registry, fonts)
    for _, position, color, uiElement, text in
        registry:each(
            "position",
            "color",
            "uiElement",
            "uiText"
        )
    do
        if Canvas.isActive(
            registry,
            uiElement.canvasId
        ) then
            local font = fonts[text.font] or fonts.normal

            love.graphics.setFont(font)

            love.graphics.setColor(
                color.r,
                color.g,
                color.b
            )

            love.graphics.printf(
                text.value,
                position.x,
                position.y,
                text.width,
                text.align
            )
        end
    end
end

local function drawButtons(registry, fonts)
    for entity,
        position,
        rectangle,
        color,
        uiElement,
        button
    in
        registry:each(
            "position",
            "rectangle",
            "color",
            "uiElement",
            "button"
        )
    do
        local _, canvas =
            Canvas.get(
                registry,
                uiElement.canvasId
            )

        if canvas and canvas.active then
            local isActive =
                button.active ~= false

            local isSelected =
                isActive and
                canvas.selectedIndex ==
                    button.index

            if not isActive then
                love.graphics.setColor(
                    color.r * 0.35,
                    color.g * 0.35,
                    color.b * 0.35
                )

            elseif isSelected then
                love.graphics.setColor(
                    0.35,
                    0.65,
                    1
                )

            else
                love.graphics.setColor(
                    color.r,
                    color.g,
                    color.b
                )
            end

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
                registry:get(
                    entity,
                    "outline"
                )

            if outline then
                if not isActive then
                    love.graphics.setLineWidth(2)
                    love.graphics.setColor(
                        0.35,
                        0.35,
                        0.35
                    )

                elseif isSelected then
                    love.graphics.setLineWidth(4)
                    love.graphics.setColor(
                        1,
                        1,
                        0.3
                    )

                else
                    love.graphics.setLineWidth(
                        outline.width
                    )

                    love.graphics.setColor(
                        outline.color.r,
                        outline.color.g,
                        outline.color.b
                    )
                end

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

            love.graphics.setFont(
                fonts.button
            )

            if isActive then
                love.graphics.setColor(1, 1, 1)
            else
                love.graphics.setColor(
                    0.5,
                    0.5,
                    0.5
                )
            end

            local fontHeight =
                fonts.button:getHeight()

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
end

function UISystem.draw(scene)
    local registry = scene.registry

    local _, resources =
        registry:first("uiResources")

    if not resources then
        -- Debug
        print("Error: no se encontraron recursos UI")
        return
    end

    drawCanvasBackgrounds(registry)

    drawTexts(
        registry,
        resources.fonts
    )

    drawButtons(
        registry,
        resources.fonts
    )

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end

return UISystem