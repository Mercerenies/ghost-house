extends Node
class_name StatusEffectCodex

const ID_DebugEffect = 1
const ID_TiredEffect = 2
const ID_HyperEffect = 3
const ID_InvincibleEffect = 4
const ID_BlindedEffect = 5
const ID_NightVisionEffect = 6
const ID_DarknessEffect = 7
const ID_PerfectVisionEffect = 8
const ID_SlowedEffect = 9

static func get_status_script(id: int) -> Script:
    match id:
        ID_DebugEffect:
            return load("res://StatusEffect/DebugEffect.gd") as Script
        ID_TiredEffect:
            return load("res://StatusEffect/TiredEffect.gd") as Script
        ID_HyperEffect:
            return load("res://StatusEffect/HyperEffect.gd") as Script
        ID_InvincibleEffect:
            return load("res://StatusEffect/InvincibleEffect.gd") as Script
        ID_BlindedEffect:
            return load("res://StatusEffect/BlindedEffect.gd") as Script
        ID_NightVisionEffect:
            return load("res://StatusEffect/NightVisionEffect.gd") as Script
        ID_DarknessEffect:
            return load("res://StatusEffect/DarknessEffect.gd") as Script
        ID_PerfectVisionEffect:
            return load("res://StatusEffect/PerfectVisionEffect.gd") as Script
        ID_SlowedEffect:
            return load("res://StatusEffect/SlowedEffect.gd") as Script
