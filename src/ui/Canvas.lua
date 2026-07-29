local Canvas = {}

function Canvas.create(registry, options)
    options = options or {}

    return registry:spawn({
        canvas = {
            id = options.id,
            active = options.active == true,
            blocksGameplay = options.blocksGameplay == true,
            interactive = options.interactive == true,
            navigation = options.navigation or "vertical",
            selectedIndex = options.selectedIndex or 1,
            priority = options.priority or 0,
            dim = options.dim or 0
        }
    })
end

function Canvas.createText(registry, options)
    return registry:spawn({
        position = {
            x = options.x or 0,
            y = options.y or 0
        },

        color = options.color or {
            r = 1,
            g = 1,
            b = 1
        },

        uiElement = {
            canvasId = options.canvasId
        },

        uiText = {
            id = options.id,
            value = options.value or "",
            font = options.font or "normal",
            width = options.width or love.graphics.getWidth(),
            align = options.align or "left"
        }
    })
end

function Canvas.createButton(registry, options)
    return registry:spawn({
        position = {
            x = options.x,
            y = options.y
        },

        rectangle = {
            width = options.width,
            height = options.height
        },

        color = options.color or {
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

        uiElement = {
            canvasId = options.canvasId
        },

        button = {
            text = options.text,
            action = options.action,
            index = options.index,
            active = options.active ~= false
        }
    })
end

function Canvas.get(registry, canvasId)
    for entity, canvas in
        registry:each("canvas")
    do
        if canvas.id == canvasId then
            return entity, canvas
        end
    end

    return nil, nil
end

function Canvas.show(registry, canvasId)
    local _, canvas =
        Canvas.get(registry, canvasId)

    if canvas then
        canvas.active = true
    end
end

function Canvas.hide(registry, canvasId)
    local _, canvas =
        Canvas.get(registry, canvasId)

    if canvas then
        canvas.active = false
    end
end

function Canvas.isActive(registry, canvasId)
    local _, canvas =
        Canvas.get(registry, canvasId)

    return canvas and canvas.active
end

function Canvas.blocksGameplay(registry)
    for _, canvas in
        registry:each("canvas")
    do
        if canvas.active
            and canvas.blocksGameplay then

            return true
        end
    end

    return false
end

function Canvas.getActiveInteractive(registry)
    local selectedCanvas = nil

    for _, canvas in
        registry:each("canvas")
    do
        if canvas.active
            and canvas.interactive then

            if not selectedCanvas
                or canvas.priority >
                    selectedCanvas.priority then

                selectedCanvas = canvas
            end
        end
    end

    return selectedCanvas
end

function Canvas.setText(
    registry,
    textId,
    value,
    color
)
    for _, text, textColor in
        registry:each(
            "uiText",
            "color"
        )
    do
        if text.id == textId then
            text.value = value

            if color then
                textColor.r = color.r
                textColor.g = color.g
                textColor.b = color.b
            end

            return
        end
    end
end

return Canvas