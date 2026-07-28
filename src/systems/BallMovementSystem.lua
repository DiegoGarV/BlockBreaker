local BallMovementSystem = {}

function BallMovementSystem.update(scene, dt)
    local registry = scene.registry
    local _, game = registry:first("game")

    if not game or game.state ~= "playing" then
        return
    end

    for _, position, velocity in
        registry:each(
            "position",
            "velocity"
        )
    do
        position.x = position.x + velocity.x * dt
        position.y = position.y + velocity.y * dt
    end
end

return BallMovementSystem