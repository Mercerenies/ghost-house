tool
extends Node2D

export(float, 0, 128, 1) var radius: float = 16.0

func _draw() -> void:
    draw_circle(Vector2(), radius, Color.white)
