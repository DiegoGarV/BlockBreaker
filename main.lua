function createBlock(x, y, width, height, color)
    return {
        x = x,
        y = y,
        width = width,
        height = height,
        color = color
    }
end

function blockGrid(rows, columns, colors, margins)
    local newBlocks = {}
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    margins = margins or {}
    local left = margins.left or 0
    local right = margins.right or 0
    local top = margins.top or 0
    local bottom = margins.bottom or 0
    local gridAreaHeight = screenHeight * (7/12)
    local availableWidth = screenWidth - left - right
    local availableHeight = gridAreaHeight - top - bottom
    local blockWidth = availableWidth / columns
    local blockHeight = availableHeight / rows

    for row = 1, rows do
        local colorIndex = ((row - 1) % #colors) + 1
        local rowColor = colors[colorIndex]

        for column = 1, columns do
            local blockX = left + (column - 1) * blockWidth
            local blockY = top + (row - 1) * blockHeight

            local block = createBlock(
                blockX,
                blockY,
                blockWidth,
                blockHeight,
                rowColor
            )

            table.insert(newBlocks, block)
        end
    end

    return newBlocks
end

function resetGame()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    paddle = {
        width = 120,
        height = 20,
        x = screenWidth / 2 - 120 / 2,
        y = screenHeight - 60,
        speed = 400
    }

    ball = {
        x = screenWidth / 2,
        y = screenHeight - 80,
        radius = 10,
        speedX = 0,
        speedY = -200,
        speedIncrease = 1.10,
        maxSpeed = 700
    }

    local blockColors = {
        {1, 0.2, 0.2},
        {0.2, 1, 0.2},
        {0.2, 0.4, 1},
        {1, 0.8, 0.2}
    }

    blocks = blockGrid(6, 8, blockColors, {top = 40, left = 40, right = 40})

    gameState = "playing"
end

function drawGame()
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

    -- Bloques
    love.graphics.setLineWidth(2)
    for _, block in ipairs(blocks) do
        love.graphics.setColor(
            block.color[1],
            block.color[2],
            block.color[3]
        )
        love.graphics.rectangle(
            "fill",
            block.x,
            block.y,
            block.width,
            block.height
        )

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle(
            "line",
            block.x,
            block.y,
            block.width,
            block.height
        )
    end
end

function drawEndScreen(message, messageColor)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    love.graphics.setFont(titleFont)
    love.graphics.setColor(
        messageColor[1],
        messageColor[2],
        messageColor[3]
    )
    love.graphics.printf(
        message,
        0,
        screenHeight / 2 - 100,
        screenWidth,
        "center"
    )

    love.graphics.setFont(optionFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        "Press 'R' to replay",
        0,
        screenHeight / 2,
        screenWidth,
        "center"
    )
    love.graphics.printf(
        "Press 'Q' to quit",
        0,
        screenHeight / 2 + 50,
        screenWidth,
        "center"
    )
end

function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    titleFont = love.graphics.newFont(48)
    optionFont = love.graphics.newFont(24)

    resetGame()
    print("El juego inició correctamente")
end

function love.update(dt)
    if gameState ~= "playing" then
        return
    end

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

    -- Interacción pelota/bloques
    for i = #blocks, 1, -1 do
        local block = blocks[i]

        local ballTouchesBlock =
        ball.x + ball.radius >= block.x and
        ball.x - ball.radius <= block.x + block.width and
        ball.y + ball.radius >= block.y and
        ball.y - ball.radius <= block.y + block.height

        if ballTouchesBlock then
            local overlapLeft = (ball.x + ball.radius) - block.x
            local overlapRight = (block.x + block.width) - (ball.x - ball.radius)
            local overlapTop = (ball.y + ball.radius) - block.y
            local overlapBottom = (block.y + block.height) - (ball.y - ball.radius)

            local smallestOverlap = math.min(
                overlapLeft,
                overlapRight,
                overlapTop,
                overlapBottom
            )

            if smallestOverlap == overlapLeft then
                ball.x = block.x - ball.radius
                ball.speedX = -math.abs(ball.speedX)
            elseif smallestOverlap == overlapRight then
                ball.x = block.x + block.width + ball.radius
                ball.speedX = math.abs(ball.speedX)
            elseif smallestOverlap == overlapTop then
                ball.y = block.y - ball.radius
                ball.speedY = -math.abs(ball.speedY)
            elseif smallestOverlap == overlapBottom then
                ball.y = block.y + block.height + ball.radius
                ball.speedY = math.abs(ball.speedY)
            end

            table.remove(blocks, i)
            break
        end
    end

    -- Ganar
    if #blocks == 0 then
        gameState = "won"
    end

    -- Perder
    if ball.y - ball.radius >= love.graphics.getHeight() then
        gameState = "lost"
    end
end

function love.keypressed(key)
    if gameState == "won" or gameState == "lost" then
        if key == "r" then
            resetGame()
        elseif key == "q" then
            love.event.quit()
        end
    end
end

function love.draw()
    function love.draw()
        love.graphics.clear(0.1, 0.1, 0.15)

        if gameState == "playing" then
            drawGame()
        elseif gameState == "won" then
            drawEndScreen("You Win!", {0.2, 1, 0.3})
        elseif gameState == "lost" then
            drawEndScreen("Game Over", {1, 0.2, 0.2})
        end
    end
end