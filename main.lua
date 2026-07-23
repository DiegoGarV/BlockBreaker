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
end