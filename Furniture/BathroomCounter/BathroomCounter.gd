extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A counter to place your toiletries on." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4
    set_dims(Vector2(2, 1) if a % 2 == 1 else Vector2(1, 2))

func get_furniture_name() -> String:
    return "BathroomCounter"

func get_shim_channel() -> int:
    if vars["vanishing"]:
        return ShimChannel.NoShim
    return ShimChannel.BathroomCounterNS if get_dims().y == 2 else ShimChannel.BathroomCounterWE

func get_storage_chance() -> float:
    return 1.0

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
