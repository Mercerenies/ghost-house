extends StaticEntity
class_name Furniture

const FlyingFairySpawner = preload("res://FlyingFairySpawner/FlyingFairySpawner.tscn")

enum ShimChannel {
    NoShim = 0,
    KitchenCounterWE = 1,
    KitchenCounterNS = 2,
    BathroomCounterWE = 3,
    BathroomCounterNS = 4,
}

var interaction: Dictionary = {}
var vars: Dictionary = {
    "vanishing": false,
    "flying_fairy": false,
}
var fairy_spawner = null

var increase_in_alpha: float = 1.2
var decrease_in_alpha: float = 0.4

func _init():
    # Every furniture node gets a flying fairy spawner automatically. It's
    # disabled by default
    fairy_spawner = FlyingFairySpawner.instance()
    fairy_spawner.set_entity(self)
    add_child(fairy_spawner)
    vars['furniture_name']  = get_furniture_name()

func _ready():
    # DEBUG CODE
    interaction['evil'] = [
        { "command": "action", "action": "harm_player", "arg": 1 },
        { "command": "action", "action": "furniture_drop", "arg": evil_drop_sprite() },
        { "command": "say", "text": "Ouch!" }
    ]
    interaction['debug_dump'] = [
        { "command": "dump_vars" }
    ]

func _process(delta: float) -> void:
    if vars['vanishing']:
        var distance = EnemyAI.distance_to_player(self)
        var dir = EnemyAI.player_line_of_sight(self)
        var distance_a = clamp((1 / 128.0) * (192 - distance), 0, 1)
        var dir_a = clamp((4.0 / PI) * (PI / 2.0 - dir), 0, 1)
        var target_a = round(max(distance_a, dir_a))
        var change_a = increase_in_alpha if modulate.a < target_a else decrease_in_alpha
        modulate.a = Util.toward(modulate.a, change_a * delta, target_a)
    else:
        modulate.a = 1.0

func on_interact() -> void:
    if not interaction.empty():
        if vars['vanishing']:
            get_room().show_dialogue(interaction, "evil", vars)
        else:
            get_room().show_dialogue(interaction, "idle", vars)

func on_debug_tap() -> void:
    get_room().show_dialogue(interaction, "debug_dump", vars)

func chance_of_turning_evil() -> float:
    # This is multiplied by the global room chance, so make it slightly larger or smaller than 1.0
    # to manipulate it. Make it 0.0 if you want this furniture to never be evil
    return 1.0

func turn_evil() -> void:
    # 10% chance of spawning fairies (if no natural light is emitted). In any other case,
    # be vanishing
    if (not naturally_emits_light()) and randf() < 0.10:
        vars['flying_fairy'] = true
        fairy_spawner.activate()
    else:
        vars['vanishing'] = true

func evil_drop_sprite() -> Sprite:
    return $Sprite as Sprite # God, I hope this exists. If it doesn't, override this method!

# TODO Make this return string. It's an easy fix but I'm too lazy to do it right now.
func get_furniture_name():
    return "Furniture"

func get_shim_channel() -> int:
    return ShimChannel.NoShim