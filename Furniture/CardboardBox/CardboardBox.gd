extends Furniture

# TODO Consider having these open themselves up and close again just
# to mess with the player.

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A box with various knick-knacks in it." }
    ]
    $Sprite.frame = randi() % 2

func set_direction(_a: int):
    pass # This one actually doesn't depend on direction, for once.

func get_furniture_name() -> String:
    return "CardboardBox"

func get_storage_chance() -> float:
    return 2.0

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
