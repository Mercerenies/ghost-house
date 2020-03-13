extends FurnitureInteraction

var furniture
var interaction

func _init(furniture) -> void:
    self.furniture = furniture

    interaction = {
        "evil": [
            { "command": "action", "action": "harm_player", "arg": 1 },
            { "command": "action", "action": "furniture_drop", "arg": furniture.evil_drop_sprite() },
            { "command": "end" },
        ]
    }

func is_active() -> bool:
    return furniture.vars['vanishing']

func perform_interaction() -> void:
    var room = furniture.get_room()
    room.show_dialogue(interaction, "evil", {})
