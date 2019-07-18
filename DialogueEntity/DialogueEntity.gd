extends MobileEntity
class_name DialogueEntity

export var dialogue: Dictionary = {}

func _ready() -> void:
    pass

func on_interact() -> void:
    if not dialogue.empty():
        get_room().show_dialogue(dialogue)
    else:
        .on_interact()