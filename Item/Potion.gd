extends Item

# Metadata for a potion should be a dictionary containing exactly two keys:
#
# - "status_id": The status effect ID
#
# - "status_length": The length of the status effect in seconds, or -1
#   for infinite length.

const ACTION_DRINK = 3001

func get_id(_instance) -> int:
    return ItemCodex.ID_Potion

func get_name(instance) -> String:
    var meta = instance.get_metadata()
    var status_effect = StatusEffectCodex.get_status(meta['status_id'])
    return "{} Potion".format([status_effect.get_potion_name()], "{}")

func get_description(instance) -> String:
    var meta = instance.get_metadata()
    var status_effect = StatusEffectCodex.get_status(meta['status_id'])
    var text = "Grants the user the {} effect.".format([status_effect.get_potion_name()], "{}")
    if meta['status_length'] >= 0:
        text += " (Length %d:%02d)" % [meta['status_length'] / 60, meta['status_length'] % 60]
    else:
        text += " (Length Indefinite)"
    return text

func get_icon_index(instance) -> int:
    var id = instance.get_metadata()['status_id']
    match id:
        StatusEffectCodex.ID_TiredEffect:
            return 6
        StatusEffectCodex.ID_HyperEffect:
            return 3
        StatusEffectCodex.ID_InvincibleEffect:
            return 5
        StatusEffectCodex.ID_BlindedEffect:
            return 7
        StatusEffectCodex.ID_NightVisionEffect:
            return 4
        StatusEffectCodex.ID_SlowedEffect:
            return 8
        _:
            # This is not just a backup case; icon 2 is actually used
            # if the potion is for a debug-only status effect such as
            # ID_DebugEffect.
            return 2

func get_tags(_instance) -> Array:
   return [CollectibleTag.SHORT_TERM]

func _get_actions_app(out: Array, instance):
    out.append(ACTION_DRINK)
    out.append(ACTION_DROP)
    ._get_actions_app(out, instance)

func do_action(room: Room, instance, action_id: int) -> void:
    match action_id:
        ACTION_DRINK:
            var meta = instance.get_metadata()
            var status_effect = StatusEffectCodex.get_status(meta['status_id'])
            room.get_pause_menu().unpause()
            var stats = room.get_player_stats()
            stats.get_inventory().erase_item(instance)
            stats.get_status_effects().apply_status_effect(StatusInstance.new(status_effect, meta['status_length']))
        _:
            .do_action(room, instance, action_id)

static func action_name(action: int) -> String:
    match action:
        ACTION_DRINK:
            return "Drink"
        _:
            return .action_name(action)
