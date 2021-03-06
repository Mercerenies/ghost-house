extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A large cabinet above a set of drawers." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4
    set_dims(Vector2(2, 1) if a % 2 == 1 else Vector2(1, 2))

func get_furniture_name() -> String:
    return "LongCabinet"

func get_storage_chance() -> float:
    return 1.5

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
