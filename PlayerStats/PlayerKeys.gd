tool
extends Node2D

export var max_displayed: int = 5
export var keys: int = 0

const _image: Texture = preload("res://PlayerStats/Key.png")

func _ready():
    pass

func _draw() -> void:
    var shown = min(max_displayed, keys)
    if Engine.editor_hint:
        shown = max_displayed

    for i in range(shown):
        var pos = Vector2(i * 32, 0)
        draw_texture(_image, pos)

func set_keys(a: int) -> void:
    keys = int(max(a, 0))
    update()

func get_keys() -> int:
    return keys
