extends Node2D

# This is all DEBUG CODE, of course

var _sample_dialogue = {
    "start": [
        {"command": "say", "text": "Hi, I'm your friendly neighborhood dialogue box. I'm here to help. Press SPACEBAR and stuff will happen."},
#        {"command": "say", "text": "You did it! You defeated me!"},
#        {"command": "branch", "speaker": "Box", "text": "Are you done?", "options": [
#            { "text": "No, continue.", "state": "state2" },
#            { "text": "Yes, done.", "state": "end" },
#            { "text": "Say again.", "state": "start" },
#            { "text": "Say again 1.", "state": "start" },
#            { "text": "Say again 2.", "state": "start" },
#            { "text": "Say again 3.", "state": "start" }
#        ]}
        {"command": "end"}
    ],
    "state2": [
        {"command": "say", "text": "Welcome to State 2."},
        {"command": "say", "speaker": "Box", "text": "By the way, I have an identity now"},
        {"command": "say", "text": "Not now though"},
        {"command": "end"}
    ],
    "end": []
}

func _ready():
    $Room.get_dialogue_box().popup(_sample_dialogue)
