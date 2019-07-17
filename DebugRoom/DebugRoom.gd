extends Node2D

# This is all DEBUG CODE, of course

var _sample_dialogue = {
    "start": [
        {"command": "say", "text": "Hi, I'm your friendly neighborhood dialogue box. I'm here to help. Press SPACEBAR and stuff will happen."},
        {"command": "say", "text": "You did it! You defeated me!"},
        {"command": "goto", "target": "state2"}
    ],
    "state2": [
        {"command": "say", "text": "Welcome to State 2."},
        {"command": "end"}
    ]
}

func _ready():
    $Room/DialogueBox.popup(_sample_dialogue)
