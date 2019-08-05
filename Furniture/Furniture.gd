extends StaticEntity
class_name Furniture

var interaction: Dictionary = {}

func _ready():
    pass

func on_interact() -> void:
    if not interaction.empty():
        get_room().show_dialogue(interaction, "idle")