extends Furniture

var _image_type: int = -1

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "An old-fashioned automobile." }
    ]
    if _image_type == -1:
        _image_type = randi() % $Sprite.vframes
    $Sprite.frame = 4 * _image_type + ($Sprite.frame % 4)

func set_image_type(a: int):
    _image_type = a

func set_direction(a: int):
    $Sprite.frame = 4 * _image_type + a

func get_furniture_name():
    return "Automobile"
