local PaddleControlSystem = {}

function PaddleControlSystem.update(scene, dt)
    local registry = scene.registry
    local _, game = registry:first("game")

    if not game or game.state ~= "playing" then
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
        local direction = 0

        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            direction = direction - 1
        end

        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            direction = direction + 1
        end

        position.x = position.x + direction * paddle.speed * dt

        if position.x < 0 then
            position.x = 0
        end

        if position.x + rectangle.width > screenWidth then
            position.x = screenWidth - rectangle.width
        end
    end
end

return PaddleControlSystem