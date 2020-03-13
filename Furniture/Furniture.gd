extends StaticEntity
class_name Furniture

const FlyingFairySpawner = preload("res://FlyingFairySpawner/FlyingFairySpawner.tscn")
const FurnitureVanishEffect = preload("res://Furniture/FurnitureVanishEffect.tscn")

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

func _init():
    vars['furniture_name']  = get_furniture_name()

func _ready():
    # DEBUG CODE
    interaction['evil'] = [
        { "command": "action", "action": "harm_player", "arg": 1 },
        { "command": "action", "action": "furniture_drop", "arg": evil_drop_sprite() },
#        { "command": "say", "text": "Ouch!" },
        { "command": "end" },
    ]
    interaction['debug_dump'] = [
        { "command": "dump_vars" }
    ]

# Appends the interactions for this furniture to the array argument.
# Generally, implementations of this method should append
# FurnitureInteraction objects to the end of the array and then call
# the super method at the very end, unless there's a very good reason
# to override the priority of subclasses.
func _get_interactions_app(out: Array) -> void:
    pass

# Do NOT override this method. Override _get_interactions_app instead.
func get_interactions() -> Array:
    var arr = []
    _get_interactions_app(arr)
    return arr

func on_interact() -> void:
    var interactions = get_interactions()
    for inter in interactions:
        if inter.is_active():
            inter.perform_interaction()
            break
    #if not interaction.empty():
    #    if vars['vanishing']:
    #        get_room().show_dialogue(interaction, "evil", vars)
    #    else:
    #        get_room().show_dialogue(interaction, "idle", vars)

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
        var fairy_spawner = FlyingFairySpawner.instance()
        fairy_spawner.set_entity(self)
        add_child(fairy_spawner)
        fairy_spawner.activate()
        vars['flying_fairy'] = true
    else:
        var vanish = FurnitureVanishEffect.instance()
        add_child(vanish)
        vanish.connect("alpha_changed", self, "_on_FurnitureVanishEffect_alpha_changed")
        vars['vanishing'] = true

func evil_drop_sprite() -> Sprite:
    return $Sprite as Sprite # God, I hope this exists. If it doesn't, override this method!

# TODO Make this return string. It's an easy fix but I'm too lazy to do it right now.
func get_furniture_name():
    return "Furniture"

func get_shim_channel() -> int:
    return ShimChannel.NoShim

func on_alpha_updated() -> void:
    pass

func _on_FurnitureVanishEffect_alpha_changed(_new_alpha: float) -> void:
    on_alpha_updated()
