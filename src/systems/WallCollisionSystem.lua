local WallCollisionSystem = {}

function WallCollisionSystem.update(scene, dt)
    local registry = scene.registry

    local _, game = registry:first("game")

    if not game or game.state ~= "playing" then
        return
    end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    for _, position, velocity, circle, ball in
        registry:each(
            "position",
            "velocity",
            "circle",
            "ball"
        )
    do
        -- Pared izquierda
        if position.x - circle.radius <= 0 then
            position.x = circle.radius
            velocity.x = math.abs(velocity.x)
        end

        -- Pared derecha
        if position.x + circle.radius >= screenWidth then
            position.x = screenWidth - circle.radius
            velocity.x = -math.abs(velocity.x)
        end

        -- Pared superior
        if position.y - circle.radius <= 0 then
            position.y = circle.radius
            velocity.y = math.abs(velocity.y)
        end

        -- Pared inferior: lose condition
        if position.y - circle.radius >= screenHeight then
            game.state = "lost"
        end
    end
end

return WallCollisionSystem