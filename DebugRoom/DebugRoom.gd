extends Node2D

# This is all DEBUG CODE, of course

var _sample_dialogue = {
    "idle": [
        {"command": "say", "text": "Hi, I'm your friendly neighborhood dialogue box. I'm here to help. Press SPACEBAR and stuff will happen."},
        {"command": "say", "text": "You did it! You defeated me!"},
        {"command": "branch", "speaker": "Box", "text": "Are you done?", "options": [
            { "text": "No, continue.", "state": "state2" },
            { "text": "Yes, done.", "state": "end" },
            { "text": "Say again.", "state": "idle" },
            { "text": "Say again 1.", "state": "idle" },
            { "text": "Say again 2.", "state": "idle" },
            { "text": "Say again 3.", "state": "idle" }
        ]},
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
    #$Room.get_dialogue_box().popup(_sample_dialogue, "idle")
    $Room.get_marked_entities()[Mark.PLAYER] = $Room/Entities/Player
    $Room/Entities/LongBookshelf.turn_evil()
    $Room/Entities/OfficeChair.turn_evil()
    $Room/Entities/LaundryMachine.turn_evil()

    $Room/Entities/KitchenCounter.unposition_self()
    $Room/Entities/KitchenCounter2.unposition_self()
    $Room/Entities/KitchenCounter.set_direction(0)
    $Room/Entities/KitchenCounter2.set_direction(0)
    $Room/Entities/KitchenCounter.position_self()
    $Room/Entities/KitchenCounter2.position_self()

    $Room/Entities/LockedDoor.set_direction(1)

func _on_Player_player_moved(_speed: float):
    $Room.get_minimap().update_map()
