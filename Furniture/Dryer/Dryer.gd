extends Furniture

const SlidingFurnitureBehavior = preload("res://SlidingFurnitureBehavior/SlidingFurnitureBehavior.tscn")

func _init() -> void:
    vars["sliding_furniture"] = false

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A dryer. It doesn't appear to be in use right now." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func chance_of_turning_evil() -> float:
    return 2.0

func turn_evil() -> void:
    # 60% chance of having flying books, 40% chance of default behavior
    if randf() < 0.6:
        vars['sliding_furniture'] = true
        var behavior = SlidingFurnitureBehavior.instance()
        add_child(behavior)
        # Have to defer the call since the player probably doesn't
        # exist yet, but he will in one more frame.
        behavior.call_deferred("activate")
    else:
        .turn_evil()

func get_furniture_name() -> String:
    return "Dryer"

func get_storage_chance() -> float:
    return 0.2

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
