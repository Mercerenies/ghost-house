extends DialogueEntity

func _ready():
    dialogue = {
        "idle": [
            {"command": "say", "speaker": "A Ghost", "text": "Hi, I'm a ghost :)"}
        ]
    }
