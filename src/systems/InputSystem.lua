local GameSetupSystem = require("src.systems.GameSetupSystem")

local InputSystem = {}

function InputSystem.setup(scene)
    local registry = scene.registry

    registry:spawn({
        input = {
            paddleDirection = 0
        }
    })
end

function InputSystem.update(scene, dt)
    local registry = scene.registry

    local _, game = registry:first("game")
    local _, input = registry:first("input")

    if not game then
        -- Debug
        print("Error: no se encontró el estado del juego")
        return
    end

    if not input then
        -- Debug
        print("Error: no se encontró el componente input")
        return
    end

    input.paddleDirection = 0

    -- Input del paddle
    if game.state == "playing" then
        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            input.paddleDirection =
                input.paddleDirection - 1
        end

        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            input.paddleDirection =
                input.paddleDirection + 1
        end
    end

    -- Input de UI
    for eventEntity, keyPressed in
        registry:each("keyPressed")
    do
        local key = keyPressed.key

        if game.state == "won"
            or game.state == "lost" then

            if key == "r" then
                GameSetupSystem.reset(scene)

            elseif key == "q" then
                love.event.quit()
            end
        end

        registry:destroy(eventEntity)
    end
end

return InputSystem