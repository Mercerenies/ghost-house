extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A machine for washing dishes." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func get_furniture_name() -> String:
    return "Dishwasher"

func get_shim_channel() -> int:
    if vars["vanishing"]:
        return ShimChannel.NoShim
    return ShimChannel.KitchenCounterNS if $Sprite.frame % 2 == 1 else ShimChannel.KitchenCounterWE

func get_storage_chance() -> float:
    return 0.2

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
