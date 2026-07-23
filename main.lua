function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    paddle = {
        width = 120,
        height = 20,
        x = 340,
        y = 540,
        speed = 400
    }

    ball = {
        x = 400,
        y = 300,
        radius = 10,
        speedX = 0,
        speedY = 200,
        speedIncrease = 1.10,
        maxSpeed = 700
    }

    print("El juego inició correctamente")
end

function love.update(dt)
    -- Movimiento del paddle
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        paddle.x = paddle.x - paddle.speed * dt
    end

    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        paddle.x = paddle.x + paddle.speed * dt
    end

    if paddle.x < 0 then
        paddle.x = 0
    end

    if paddle.x + paddle.width > love.graphics.getWidth() then
        paddle.x = love.graphics.getWidth() - paddle.width
    end

    -- Movimiento de la pelota
    ball.x = ball.x + ball.speedX * dt
    ball.y = ball.y + ball.speedY * dt

    if ball.x - ball.radius <= 0 then
        ball.x = ball.radius
        ball.speedX = -ball.speedX
    end

    if ball.x + ball.radius >= love.graphics.getWidth() then
        ball.x = love.graphics.getWidth() - ball.radius
        ball.speedX = -ball.speedX
    end

    if ball.y - ball.radius <= 0 then
        ball.y = ball.radius
        ball.speedY = -ball.speedY
    end

    if ball.y - ball.radius >= love.graphics.getHeight() then
        print("Game Over")
        love.event.quit()
    end

    -- Interacción pelota/paddle
    local ballTouchesPaddle =
        ball.x + ball.radius >= paddle.x and
        ball.x - ball.radius <= paddle.x + paddle.width and
        ball.y + ball.radius >= paddle.y and
        ball.y - ball.radius <= paddle.y + paddle.height

    if ballTouchesPaddle and ball.speedY > 0 then
        ball.y = paddle.y - ball.radius
        ball.speedY = -ball.speedY

        local paddleCenter = paddle.x + paddle.width / 2
        local distanceFromCenter = ball.x - paddleCenter
        local normalizedDistance = distanceFromCenter / (paddle.width / 2)

        ball.speedX = normalizedDistance * math.abs(ball.speedY)

        ball.speedX = ball.speedX * ball.speedIncrease
        ball.speedY = ball.speedY * ball.speedIncrease

        ball.speedX = math.max(
            -ball.maxSpeed,
            math.min(ball.speedX, ball.maxSpeed)
        )
        ball.speedY = math.max(
            -ball.maxSpeed,
            math.min(ball.speedY, ball.maxSpeed)
        )
    end
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.15)

    -- Paddle
    love.graphics.setColor(1, 1, 1)

    love.graphics.rectangle(
        "fill",
        paddle.x,
        paddle.y,
        paddle.width,
        paddle.height
    )

    -- Pelota
    love.graphics.setColor(1, 0.3, 0.3)

    love.graphics.circle(
        "fill",
        ball.x,
        ball.y,
        ball.radius
    )
end