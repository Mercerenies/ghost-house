extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A stove atop a conventional oven." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func get_furniture_name():
    return "Stove"

func get_shim_channel() -> int:
    if vars["vanishing"]:
        return ShimChannel.NoShim
    return ShimChannel.KitchenCounterNS if $Sprite.frame % 2 == 1 else ShimChannel.KitchenCounterWE
