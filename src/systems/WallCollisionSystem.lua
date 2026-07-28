local WallCollisionSystem = {}

function WallCollisionSystem.update(scene, dt)
    local registry = scene.registry
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    for entity, position, velocity, circle, _ in
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
            local alreadyOut = registry:get(entity, "outOfBounds")

            if not alreadyOut then
                registry:add(entity, "outOfBounds", {})
                registry:spawn({loseRequest = {}})
            end
        end
    end
end

return WallCollisionSystem