extends StaticEntity

const INTERACTION = {
    "no_key": [
        { "command": "say", "text": "The door is locked. If you had a key, you could open it." },
    ],
    "debug_dump": [
        { "command": "dump_vars" },
    ],
}

var vars: Dictionary = {}

func _ready() -> void:
    pass

func set_direction(a: int) -> void:
    $Sprite.frame = a % 2

func on_interact() -> void:
    # TODO Keys, obviously, if you have them
    get_room().show_dialogue(INTERACTION, "no_key", vars)

func on_debug_tap() -> void:
    get_room().show_dialogue(INTERACTION, "debug_dump", vars)
