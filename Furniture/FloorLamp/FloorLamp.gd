extends Furniture

func _ready() -> void:
    $Sprite.frame = 1
    interaction["idle"] = [
         { "command": "say", "text": "A floor lamp." }
    ]

func set_direction(_a: int):
    pass

# func on_interact() -> void:
#     if vars['vanishing']:
#         .on_interact()
#     else:
#         var light = $RadialLightSpawner.get_light()
#         light.visible = not light.visible
#         $Sprite.frame = int(light.visible)

func naturally_emits_light() -> bool:
    return true

func chance_of_turning_evil() -> float:
    return 0.10

func get_furniture_name():
    return "FloorLamp"

func on_alpha_updated() -> void:
    $RadialLightSpawner.get_light().modulate.a = modulate.a
