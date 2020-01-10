extends Furniture

# TODO Consider having these open themselves up and close again just
# to mess with the player.

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A box with various knick-knacks in it." }
    ]
    $Sprite.frame = randi() % 2

func set_direction(a: int):
    pass # This one actually doesn't depend on direction, for once.

func get_furniture_name():
    return "CardboardBox"
