extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "An old office chair." }
    ]
    vars["flying_furniture"] = false
    $FlyingFurnitureSpawner.set_entity(self)
    $FlyingFurnitureSpawner.set_sprite($Sprite)

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func turn_evil() -> void:
    # 60% chance of launching self, 40% chance of being vanishing
    if randf() < 0.6:
        vars['flying_furniture'] = true
        $FlyingFurnitureSpawner.activate()
    else:
        .turn_evil()
