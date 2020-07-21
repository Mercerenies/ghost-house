extends Furniture

func _init() -> void:
    vars["flying_clothes"] = false

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A rack with several articles of clothing hanging." }
    ]
    $FlyingClothesSpawner.set_entity(self)

func set_direction(a: int):
    $Sprite.frame = (a + 1) % 2
    if a % 2 == 1:
        set_dims(Vector2(2, 1))
        $FlyingClothesSpawner.width = 64.0
        $FlyingClothesSpawner.height = 28.0
    else:
        set_dims(Vector2(1, 2))
        $FlyingClothesSpawner.width = 32.0
        $FlyingClothesSpawner.height = 60.0

func chance_of_turning_evil() -> float:
    return 2.0

func turn_evil() -> void:
    # 80% chance of having flying clothes, 20% chance of default behavior
    if randf() < 0.8:
        vars['flying_clothes'] = true
        $FlyingClothesSpawner.activate()
    else:
        .turn_evil()

func get_furniture_name() -> String:
    return "ClothesRack"

func get_storage_chance() -> float:
    return 0.2

func get_storage_tags() -> Array:
    return [CollectibleTag.SHORT_TERM, CollectibleTag.LONG_TERM, CollectibleTag.IMMEDIATE, CollectibleTag.ESSENTIAL]
