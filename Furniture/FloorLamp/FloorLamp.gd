extends Furniture

const SimpleFunctionCallInteraction = preload("res://FurnitureInteraction/SimpleFunctionCallInteraction.gd")

func _ready() -> void:
    $Sprite.frame = 1
    interaction["idle"] = [
         { "command": "say", "text": "A floor lamp." }
    ]

func set_direction(_a: int):
    pass

func _get_interactions_app(out: Array) -> void:
    out.append(SimpleFunctionCallInteraction.new(self, "toggle_light"))
    ._get_interactions_app(out)

func naturally_emits_light() -> bool:
    return true

func chance_of_turning_evil() -> float:
    return 0.10

func get_furniture_name():
    return "FloorLamp"

func on_alpha_updated() -> void:
    $RadialLightSpawner.get_light().modulate.a = modulate.a

func toggle_light() -> void:
    var light = $RadialLightSpawner.get_light()
    light.visible = not light.visible
    $Sprite.frame = int(light.visible)
