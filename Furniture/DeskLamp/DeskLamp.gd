extends Furniture

func _ready() -> void:
    interaction["idle"] = [
         { "command": "say", "text": "A lamp on a small end table." }
    ]

func set_direction(_a: int):
    pass

func on_interact() -> void:
    if vars['vanishing']:
        .on_interact()
    else:
        $RadialLightSpawner.get_light().visible = not $RadialLightSpawner.get_light().visible
        # ///// For this and FloorLamp, a visual indicator when it changes

func naturally_emits_light() -> bool:
    return true

func chance_of_turning_evil() -> float:
    return 0.10

func get_furniture_name():
    return "DeskLamp"

func on_alpha_updated() -> void:
    $RadialLightSpawner.get_light().modulate.a = modulate.a
