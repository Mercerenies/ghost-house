extends Node2D

const TOTAL_HEIGHT = 32

const MaleGhost = preload("res://Ghost/MaleGhost.png")
const FemaleGhost = preload("res://Ghost/FemaleGhost.png")
const GhostNamer = preload("res://GhostNamer/GhostNamer.gd")

var _clue: Dictionary
var _info: GhostInfo

var _image_index: int

func _update_self() -> void:
    $Sprite.texture = MaleGhost if _info.gender == GhostNamer.Gender.Male else FemaleGhost
    var clue_text = StatementPrinter.translate(_clue)
    $Label.set_text('{} says, "{}."'.format([_info.ghost_name, clue_text], "{}"))

func fill_in_data(clue: Dictionary, info: GhostInfo) -> void:
    _clue = clue
    _info = info
    _update_self()

func _process(_delta: float) -> void:
    $Sprite.frame = 4 + _image_index # 4 = 4 * FACING_DOWNWARD

func _on_SpriteAnimationTimer_timeout() -> void:
    _image_index = (_image_index + 1) % 4
