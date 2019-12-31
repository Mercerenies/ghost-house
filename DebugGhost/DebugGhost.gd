extends DialogueEntity

func _ready():
    dialogue = {
        "idle": [
            {"command": "say", "speaker": "A Ghost", "text": "Hi, I'm a ghost :)"}
        ]
    }

func on_interact() -> void:
    get_room().show_dialogue(dialogue, "idle")