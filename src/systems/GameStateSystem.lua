local Canvas = require("src.ui.Canvas")

local GameStateSystem = {}

local function showEndScreen(
    registry,
    message,
    color
)
    Canvas.setText(
        registry,
        "endScreenTitle",
        message,
        color
    )

    local _, endCanvas =
        Canvas.get(
            registry,
            "endScreen"
        )

    if endCanvas then
        endCanvas.selectedIndex = 1
    end

    Canvas.show(
        registry,
        "endScreen"
    )
end

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

            Canvas.setText(
                registry,
                "endScreenTitle",
                "Game Over",
                {
                    r = 1,
                    g = 0.2,
                    b = 0.2
                }
            )

            Canvas.show(
                registry,
                "endScreen"
            )
        end
    end

    -- Win Condition
    if game.state ~= "playing" then
        return
    end

    local blockEntities = registry:query("block")

    if #blockEntities == 0 then
        game.state = "won"

        showEndScreen(
            registry,
            "You Win!",
            {
                r = 0.2,
                g = 1,
                b = 0.3
            }
        )
    end
end

return GameStateSystem