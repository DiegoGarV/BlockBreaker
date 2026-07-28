local GameStateSystem = {}

function GameStateSystem.update(scene, dt)
    local registry = scene.registry

    local _, game = registry:first("game")

    if not game then
        -- Debug
        print("Error: No se encontró el estado del juego")
        return
    end

    -- Lose Condition
    for requestEntity, _ in
        registry:each("loseRequest")
    do
        registry:destroy(requestEntity)

        if game.state == "playing" then
            game.state = "lost"
        end
    end

    if game.state ~= "playing" then
        return
    end

    local blockEntities = registry:query("block")

    -- Win Condition
    if #blockEntities == 0 then
        game.state = "won"
    end
end

return GameStateSystem