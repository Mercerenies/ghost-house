extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A strange green box. It does little of interest." }
    ]

func get_furniture_name():
    return "DebugGreenBox"
