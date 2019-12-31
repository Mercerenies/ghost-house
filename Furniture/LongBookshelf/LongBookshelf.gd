extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A shelf full of old books." }
    ]
    vars["flying_books"] = false
    $FlyingBookSpawner.set_entity(self)
    set_dims(Vector2(2, 1))

func set_direction(a: int):
    $Sprite.frame = (a + 1) % 2
    if a % 2 == 1:
        set_dims(Vector2(2, 1))
        $FlyingBookSpawner.width = 64.0
        $FlyingBookSpawner.height = 28.0
    else:
        set_dims(Vector2(1, 2))
        $FlyingBookSpawner.width = 32.0
        $FlyingBookSpawner.height = 60.0

func chance_of_turning_evil() -> float:
    return 3.0

func turn_evil() -> void:
    # 80% chance of having flying books, 20% chance of being vanishing
    if randf() < 0.8:
        vars['flying_books'] = true
        $FlyingBookSpawner.activate()
    else:
        .turn_evil()
