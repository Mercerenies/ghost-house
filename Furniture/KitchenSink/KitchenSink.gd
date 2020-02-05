extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "Everything but the kitchen sink... oh wait, there it is." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4
    set_dims(Vector2(2, 1) if a % 2 == 1 else Vector2(1, 2))

func get_furniture_name():
    return "KitchenSink"

func get_shim_channel() -> int:
    if vars["vanishing"]:
        return ShimChannel.NoShim
    return ShimChannel.KitchenCounterNS if get_dims().y == 2 else ShimChannel.KitchenCounterWE
