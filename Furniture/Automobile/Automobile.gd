extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "An old-fashioned automobile." }
    ]

func set_direction(a: int):
    $Sprite.frame = a

func get_furniture_name():
    return "Automobile"
