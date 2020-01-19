extends DialogueEntity

func _ready() -> void:
    $Sprite.visible = false
    dialogue = {
        "idle": [
            {"command": "say", "speaker": "A Ghost", "text": "Hi, I'm a ghost :)"}
        ]
    }

func on_interact() -> void:
    var player = get_room().get_marked_entities()['player']
    var dir = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
    dir = round(fmod((4 * dir) / (2 * PI), 4))
    dir = fmod(dir + 4, 4)
    set_direction(dir)
    get_room().show_dialogue(dialogue, "idle")
