local MainMenuScene = require("src.scenes.MainMenuScene")

local currentScene

function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    currentScene = MainMenuScene.new()
    currentScene:setup()
    print("Escena creada: " .. currentScene.name)
end

function love.update(dt)
    currentScene:update(dt)
end

function love.keypressed(key)
    currentScene.registry:spawn({keyPressed = {key = key}})
end

function love.draw()
    currentScene:draw()
end

function love.quit()
    if currentScene then
        currentScene:unload()
    end
end