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
    var room = get_room()
    var stats = room.get_player_stats()
    if stats.get_player_keys() > 0:
        # TODO Animation for using the key
        # TODO Animation for opening the door
        unposition_self()
        queue_free()
        stats.add_player_keys(-1)
    else:
        room.show_dialogue(INTERACTION, "no_key", vars)

func on_debug_tap() -> void:
    get_room().show_dialogue(INTERACTION, "debug_dump", vars)
