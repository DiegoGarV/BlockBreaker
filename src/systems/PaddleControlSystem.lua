local PaddleControlSystem = {}

function PaddleControlSystem.update(scene, dt)
    local registry = scene.registry
    local _, game = registry:first("game")
    local _, input = registry:first("input")

    if not game or game.state ~= "playing" then
        return
    end

    if not input then
        -- Debug
        print("Error: no se encontró el componente input")
        return
    end

    local screenWidth = love.graphics.getWidth()

    for _, position, rectangle, paddle in
        registry:each(
            "position",
            "rectangle",
            "paddle"
        )
    do
        position.x = position.x + input.paddleDirection * paddle.speed * dt

        if position.x < 0 then
            position.x = 0
        end

        if position.x + rectangle.width > screenWidth then
            position.x = screenWidth - rectangle.width
        end
    end
end

return PaddleControlSystem