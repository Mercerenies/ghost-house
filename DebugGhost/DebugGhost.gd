extends DialogueEntity

func _ready():
    dialogue = {
        "start": [
            {"command": "say", "speaker": "A Ghost", "text": "Hi, I'm a ghost :)"}
        ]
    }
