extends Furniture

var _image_index: int

func _init() -> void:
    vars["flying_clothes"] = false
    _image_index = randi() % 2

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A basket for laundry." }
    ]
    $FlyingClothesSpawner.set_entity(self)
    $Sprite.frame = _image_index

func set_direction(_a: int):
    pass

func get_furniture_name() -> String:
    return "LaundryBasket"

func turn_evil() -> void:
    # 50% chance of having flying clothes, 50% chance of default behavior
    if randf() < 0.5:
        vars['flying_clothes'] = true
        $FlyingClothesSpawner.activate()
        _image_index = 1
        if $Sprite:
            $Sprite.frame = 1
    else:
        .turn_evil()

func get_storage_chance() -> float:
    return 0.2

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
