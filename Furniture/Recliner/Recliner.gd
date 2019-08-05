extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A comfy-looking recliner." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

