extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A large wardrobe, almost big enough to walk into." }
    ]

func set_direction(a: int):
    $Sprite.frame = (5 - a) % 4

func get_furniture_name() -> String:
    return "Wardrobe"

func get_storage_chance() -> float:
    return 1.5

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
