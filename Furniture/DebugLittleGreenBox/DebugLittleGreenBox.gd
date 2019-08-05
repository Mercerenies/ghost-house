extends Furniture

func _ready() -> void:
    interaction = {
        "idle": [
             { "command": "say", "text": "A strange small green box. It does little of interest." }
        ]
    }

