extends Furniture

func _ready() -> void:
    interaction["idle"] = [
        { "command": "say", "text": "A dining room table." }
    ]

func set_direction(_a: int):
    pass

func get_furniture_name():
    return "CircularDiningTable"
