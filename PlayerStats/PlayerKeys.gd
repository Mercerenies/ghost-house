tool
extends Node2D

export var max_displayed: int = 5
export var per_row: int = 5
export var keys: int = 0

const _image: Texture = preload("res://PlayerStats/Key.png")

func _ready():
    pass

func _draw() -> void:
    var shown = min(max_displayed, keys)
    if Engine.editor_hint:
        shown = max_displayed

    for i in range(shown):
        # warning-ignore: integer_division
        var pos = 32 * Vector2(i % per_row, i / per_row)
        draw_texture(_image, pos)

func set_keys(a: int) -> void:
    keys = int(max(a, 0))
    update()

func get_keys() -> int:
    return keys
