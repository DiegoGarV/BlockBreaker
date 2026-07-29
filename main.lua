local SceneManager = require("src.ecs.SceneManager")
local MainMenuScene = require("src.scenes.MainMenuScene")
local LevelScene = require("src.scenes.LevelScene")

function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    SceneManager.register("mainMenu", MainMenuScene.new)
    SceneManager.register("testLevel", LevelScene.new)

    SceneManager.change("mainMenu")
end

function love.update(dt)
    SceneManager.update(dt)
end

function love.keypressed(key)
    SceneManager.keypressed(key)
end

function love.draw()
    SceneManager.draw()
end

function love.quit()
    SceneManager.unload()
end