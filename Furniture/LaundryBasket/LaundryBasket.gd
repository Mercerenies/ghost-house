extends Furniture

func _init() -> void:
    vars["flying_clothes"] = false

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A basket for laundry." }
    ]
    $FlyingClothesSpawner.set_entity(self)
    $Sprite.frame = randi() % 2

func set_direction(a: int):
    pass

func get_furniture_name():
    return "LaundryBasket"

func turn_evil() -> void:
    # 50% chance of having flying clothes, 50% chance of default behavior
    if randf() < 0.5:
        vars['flying_clothes'] = true
        $FlyingClothesSpawner.activate()
    else:
        .turn_evil()
