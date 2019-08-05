extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A mirror." }
    ]

func set_direction(a: int):
    $Sprite.frame = floor(a / 2)

