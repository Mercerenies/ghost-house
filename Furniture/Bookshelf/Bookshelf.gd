extends Furniture

func _init() -> void:
    vars["flying_books"] = false

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A shelf full of old books." }
    ]
    $FlyingBookSpawner.set_entity(self)

func set_direction(a: int):
    $Sprite.frame = (a + 1) % 2

func chance_of_turning_evil() -> float:
    return 3.0

func turn_evil() -> void:
    # 80% chance of having flying books, 20% chance of being vanishing
    if randf() < 0.8:
        vars['flying_books'] = true
        $FlyingBookSpawner.activate()
    else:
        .turn_evil()
