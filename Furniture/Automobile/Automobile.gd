extends Furniture

var _image_type: int = 0

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "An old-fashioned automobile." }
    ]
    _image_type = randi() % $Sprite.vframes
    $Sprite.frame = 4 * _image_type + ($Sprite.frame % 4)

func set_direction(a: int):
    $Sprite.frame = 4 * _image_type + a

func get_furniture_name():
    return "Automobile"
