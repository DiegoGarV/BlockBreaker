local Scene = require("src.ecs.Scene")

local scene

function love.load()
    love.window.setTitle("Block Breaker")
    love.window.setMode(800, 600)

    scene = Scene.new("testLevel")

    print("Escena creada: " .. scene.name)

    local testEntity = scene.registry:spawn({
        position = {
            x = 100,
            y = 200
        },

        test = {
            message = "Entidad funcionando"
        }
    })

    print("Entidad creada: " .. testEntity)

    local position = scene.registry:get(testEntity, "position")

    print("Posición X: " .. position.x)
    print("Posición Y: " .. position.y)
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.15)
end

function love.quit()
    scene:unload()
end