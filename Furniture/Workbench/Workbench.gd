extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A workbench with some tools strewn about." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func get_furniture_name():
    return "Workbench"
