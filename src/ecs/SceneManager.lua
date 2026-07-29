local SceneManager = {currentScene = nil, sceneFactories = {}}

function SceneManager.register(name, factory)
    SceneManager.sceneFactories[name] = factory
end

function SceneManager.change(name)
    local factory = SceneManager.sceneFactories[name]

    if not factory then
        -- Debug
        print(
            "Error: no existe una escena registrada con el nombre: "
            .. tostring(name)
        )
        return
    end

    -- Descargar la escena anterior
    if SceneManager.currentScene then
        SceneManager.currentScene:unload()
    end

    -- Crear la nueva escena
    SceneManager.currentScene = factory()

    -- Ejecutar su setup
    SceneManager.currentScene:setup()

    print(
        "Escena actual: "
        .. SceneManager.currentScene.name
    )
end

function SceneManager.update(dt)
    local scene = SceneManager.currentScene

    if not scene then
        return
    end

    scene:update(dt)

    local requestEntity, request =
        scene.registry:first("sceneChangeRequest")

    if request then
        local target = request.target

        scene.registry:destroy(requestEntity)

        SceneManager.change(target)
    end
end

function SceneManager.draw()
    if SceneManager.currentScene then
        SceneManager.currentScene:draw()
    end
end

function SceneManager.keypressed(key)
    if not SceneManager.currentScene then
        return
    end

    SceneManager.currentScene.registry:spawn({
        keyPressed = {
            key = key
        }
    })
end

function SceneManager.unload()
    if SceneManager.currentScene then
        SceneManager.currentScene:unload()
        SceneManager.currentScene = nil
    end
end

return SceneManager