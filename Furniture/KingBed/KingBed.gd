extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A luxurious king-sized bed." }
    ]

func set_direction(a: int):
    $Sprite.frame = a

func get_furniture_name():
    return "KingBed"
