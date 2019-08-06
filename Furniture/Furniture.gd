extends StaticEntity
class_name Furniture

var interaction: Dictionary = {}
var vars: Dictionary = {
    "vanishing": false
}

var change_in_alpha: float = 1.0

func _ready():
    # DEBUG CODE
    interaction['evil'] = [
         { "command": "say", "text": "Ouch!" }
    ]

func _process(delta: float) -> void:
    var player = get_room().get_marked_entities()['player']
    if vars['vanishing']:
        var distance = (player.position - position).length()
        var dir = abs((position - player.position).angle_to(Vector2(1, 0).rotated(player.get_direction() * PI / 2.0)))
        var distance_a = clamp((1 / 128.0) * (192 - distance), 0, 1)
        var dir_a = clamp((4.0 / PI) * (PI / 2.0 - dir), 0, 1)
        modulate.a = Util.toward(modulate.a, change_in_alpha * delta, max(distance_a, dir_a))
    else:
        modulate.a = 1.0

func on_interact() -> void:
    if not interaction.empty():
        if vars['vanishing']:
            get_room().show_dialogue(interaction, "evil")
        else:
            get_room().show_dialogue(interaction, "idle")

func chance_of_turning_evil() -> float:
    # This is multiplied by the global room chance, so make it slightly larger or smaller than 1.0
    # to manipulate it. Make it 0.0 if you want this furniture to never be evil
    return 1.0

func turn_evil() -> void:
    vars['vanishing'] = true