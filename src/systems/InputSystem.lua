local GameSetupSystem = require("src.systems.GameSetupSystem")
local Canvas = require("src.ui.Canvas")

local InputSystem = {}

InputSystem.runWhenCanvasBlocked = true

local function getCanvasButtons(
    registry,
    canvasId
)
    local buttons = {}

    for entity,
        position,
        rectangle,
        uiElement,
        button
    in
        registry:each(
            "position",
            "rectangle",
            "uiElement",
            "button"
        )
    do
        if uiElement.canvasId == canvasId and button.active ~= false then

            buttons[#buttons + 1] = {
                entity = entity,
                button = button,
                centerX = position.x + rectangle.width / 2,
                centerY = position.y + rectangle.height / 2
            }
        end
    end

    table.sort(
        buttons,
        function(a, b)
            return a.button.index < b.button.index
        end
    )

    return buttons
end

local function findSelectedButton(
    buttons,
    selectedIndex
)
    for _, entry in ipairs(buttons) do
        if entry.button.index ==
            selectedIndex then

            return entry
        end
    end

    return nil
end

local function getDirection(
    navigation,
    key
)
    if navigation == "vertical" or navigation == "grid" then

        if key == "up" or key == "w" then
            return 0, -1
        end

        if key == "down" or key == "s" then
            return 0, 1
        end
    end

    if navigation == "horizontal" or navigation == "grid" then

        if key == "left" or key == "a" then
            return -1, 0
        end

        if key == "right" or key == "d" then
            return 1, 0
        end
    end

    return nil, nil
end

local function candidateScore(
    current,
    candidate,
    directionX,
    directionY
)
    local differenceX =
        candidate.centerX -
        current.centerX

    local differenceY =
        candidate.centerY -
        current.centerY

    local primaryDistance
    local secondaryDistance

    if directionX ~= 0 then
        if differenceX * directionX <= 0 then
            return nil
        end

        primaryDistance = math.abs(differenceX)

        secondaryDistance = math.abs(differenceY)
    else
        if differenceY * directionY <= 0 then
            return nil
        end

        primaryDistance = math.abs(differenceY)

        secondaryDistance = math.abs(differenceX)
    end

    return primaryDistance * 1000 + secondaryDistance
end

local function findWrappedButton(
    buttons,
    current,
    directionX,
    directionY
)
    local best = nil
    local bestScore = nil

    for _, candidate in ipairs(buttons) do
        if candidate ~= current then
            local primary
            local secondary

            if directionX > 0 then
                primary = candidate.centerX
                secondary = math.abs(
                    candidate.centerY -
                    current.centerY
                )

            elseif directionX < 0 then
                primary = -candidate.centerX
                secondary = math.abs(
                    candidate.centerY -
                    current.centerY
                )

            elseif directionY > 0 then
                primary = candidate.centerY
                secondary = math.abs(
                    candidate.centerX -
                    current.centerX
                )

            else
                primary = -candidate.centerY
                secondary = math.abs(
                    candidate.centerX -
                    current.centerX
                )
            end

            local score = primary * 1000 + secondary

            if not bestScore
                or score < bestScore then

                best = candidate
                bestScore = score
            end
        end
    end

    return best
end

local function moveCanvasSelection(
    registry,
    canvas,
    key
)
    local directionX, directionY =
        getDirection(
            canvas.navigation,
            key
        )

    if not directionX then
        return
    end

    local buttons =
        getCanvasButtons(
            registry,
            canvas.id
        )

    if #buttons == 0 then
        return
    end

    local current =
        findSelectedButton(
            buttons,
            canvas.selectedIndex
        )

    if not current then
        canvas.selectedIndex =
            buttons[1].button.index

        return
    end

    local best = nil
    local bestScore = nil

    for _, candidate in ipairs(buttons) do
        if candidate ~= current then
            local score =
                candidateScore(
                    current,
                    candidate,
                    directionX,
                    directionY
                )

            if score and
                (
                    not bestScore or
                    score < bestScore
                )
            then
                best = candidate
                bestScore = score
            end
        end
    end

    if not best then
        best = findWrappedButton(
            buttons,
            current,
            directionX,
            directionY
        )
    end

    if best then
        canvas.selectedIndex = best.button.index
    end
end

-- Hace las acciones de cada botón al darle enter
local function activateSelectedButton(
    scene,
    registry,
    canvas
)
    for _, uiElement, button in
        registry:each(
            "uiElement",
            "button"
        )
    do
        local selected =
            uiElement.canvasId == canvas.id and 
            button.index == canvas.selectedIndex and 
            button.active ~= false

        if selected then
            if button.action == "play" then
                registry:spawn({
                    sceneChangeRequest = {
                        target = "testLevel"
                    }
                })

            elseif button.action == "restart" then
                GameSetupSystem.reset(scene)

            elseif button.action == "mainMenu" then
                registry:spawn({
                    sceneChangeRequest = {
                        target = "mainMenu"
                    }
                })

            elseif button.action == "quit" then
                love.event.quit()
            end

            return
        end
    end
end

function InputSystem.setup(scene)
    local registry = scene.registry

    local _, input = registry:first("input")

    if not input then
        registry:spawn({
            input = {
                paddleDirection = 0
            }
        })
    end
end

function InputSystem.update(scene, dt)
    local registry = scene.registry

    local _, input = registry:first("input")
    local _, game = registry:first("game") 

    if not input then
        print("Error: no se encontró el componente input")
        return
    end

    input.paddleDirection = 0

    local gameplayBlocked =
        Canvas.blocksGameplay(registry)

    if game
        and game.state == "playing"
        and not gameplayBlocked then

        if love.keyboard.isDown("a")
            or love.keyboard.isDown("left") then

            input.paddleDirection =
                input.paddleDirection - 1
        end

        if love.keyboard.isDown("d")
            or love.keyboard.isDown("right") then

            input.paddleDirection =
                input.paddleDirection + 1
        end
    end

    local activeCanvas = Canvas.getActiveInteractive(registry)

    for eventEntity, keyPressed in
        registry:each("keyPressed")
    do
        local key = keyPressed.key

        if activeCanvas then
            if key == "return" or key == "kpenter" then 
                activateSelectedButton(
                    scene,
                    registry,
                    activeCanvas
                ) 
            else
                moveCanvasSelection(
                    registry,
                    activeCanvas,
                    key
                )
            end
        end

        registry:destroy(eventEntity)
    end
end

return InputSystem