local BlockCollisionSystem = {}

function BlockCollisionSystem.update(scene, dt)
    local registry = scene.registry

    local _, game = registry:first("game")

    if not game or game.state ~= "playing" then
        return
    end

    local ballEntity = registry:query("ball")[1]

    if not ballEntity then
        -- Debug
        print("Error: No se encontró la pelota en la colisión con bloque")
        return
    end

    local ballPosition = registry:get(ballEntity, "position")
    local ballVelocity = registry:get(ballEntity, "velocity")
    local ballCircle = registry:get(ballEntity, "circle")

    for blockEntity, blockPosition, blockRectangle, _ in
        registry:each(
            "position",
            "rectangle",
            "block"
        )
    do
        local ballTouchesBlock =
            ballPosition.x + ballCircle.radius >= blockPosition.x and
            ballPosition.x - ballCircle.radius <= blockPosition.x + blockRectangle.width and
            ballPosition.y + ballCircle.radius >= blockPosition.y and
            ballPosition.y - ballCircle.radius <= blockPosition.y + blockRectangle.height

        if ballTouchesBlock then
            local overlapLeft = (ballPosition.x + ballCircle.radius) - blockPosition.x
            local overlapRight = (blockPosition.x + blockRectangle.width) - (ballPosition.x - ballCircle.radius)
            local overlapTop = (ballPosition.y + ballCircle.radius) - blockPosition.y
            local overlapBottom = (blockPosition.y + blockRectangle.height) - (ballPosition.y - ballCircle.radius)

            local smallestOverlap = math.min(
                overlapLeft,
                overlapRight,
                overlapTop,
                overlapBottom
            )

            -- Golpeó el lado izquierdo
            if smallestOverlap == overlapLeft then
                ballPosition.x = blockPosition.x - ballCircle.radius
                ballVelocity.x = -math.abs(ballVelocity.x)

            -- Golpeó el lado derecho
            elseif smallestOverlap == overlapRight then
                ballPosition.x = blockPosition.x + blockRectangle.width + ballCircle.radius
                ballVelocity.x = math.abs(ballVelocity.x)

            -- Golpeó la parte superior
            elseif smallestOverlap == overlapTop then
                ballPosition.y = blockPosition.y - ballCircle.radius
                ballVelocity.y = -math.abs(ballVelocity.y)

            -- Golpeó la parte inferior
            elseif smallestOverlap == overlapBottom then
                ballPosition.y = blockPosition.y + blockRectangle.height + ballCircle.radius
                ballVelocity.y = math.abs(ballVelocity.y)
            end

            -- Eliminar el bloque golpeado
            registry:destroy(blockEntity)
            break
        end
    end
end

return BlockCollisionSystem