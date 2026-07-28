local PaddleCollisionSystem = {}

function PaddleCollisionSystem.update(scene, dt)
    local registry = scene.registry

    local _, game = registry:first("game")

    if not game or game.state ~= "playing" then
        return
    end

    local ballEntity = registry:query("ball")[1]
    local paddleEntity = registry:query("paddle")[1]

    if not ballEntity or not paddleEntity then
        -- Debug
        print("Error: No se encontró pelota o paddle en la colisión entre ellos")
        return
    end

    local ballPosition = registry:get(ballEntity, "position")
    local ballVelocity = registry:get(ballEntity, "velocity")
    local ballCircle = registry:get(ballEntity, "circle")
    local ballData = registry:get(ballEntity, "ball")

    local paddlePosition = registry:get(paddleEntity, "position")
    local paddleRectangle = registry:get(paddleEntity, "rectangle")

    local ballTouchesPaddle =
        ballPosition.x + ballCircle.radius >= paddlePosition.x and
        ballPosition.x - ballCircle.radius <= paddlePosition.x + paddleRectangle.width and
        ballPosition.y + ballCircle.radius >= paddlePosition.y and
        ballPosition.y - ballCircle.radius <= paddlePosition.y + paddleRectangle.height

    if ballTouchesPaddle and ballVelocity.y > 0 then
        ballPosition.y = paddlePosition.y - ballCircle.radius
        ballVelocity.y = -math.abs(ballVelocity.y)

        -- Cambiar ángulo segun donde toca
        local paddleCenter = paddlePosition.x + paddleRectangle.width / 2
        local distanceFromCenter = ballPosition.x - paddleCenter
        local normalizedDistance = distanceFromCenter / (paddleRectangle.width / 2)

        -- Cambiar velocidad de la pelota
        ballVelocity.x = normalizedDistance * math.abs(ballVelocity.y)
        ballVelocity.x = ballVelocity.x * ballData.speedIncrease
        ballVelocity.y = ballVelocity.y * ballData.speedIncrease
        ballVelocity.x = math.max(
            -ballData.maxSpeed,
            math.min(
                ballVelocity.x,
                ballData.maxSpeed
            )
        )
        ballVelocity.y = math.max(
            -ballData.maxSpeed,
            math.min(
                ballVelocity.y,
                ballData.maxSpeed
            )
        )
    end
end

return PaddleCollisionSystem