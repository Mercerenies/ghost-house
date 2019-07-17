extends Polygon2D
class_name OutlinedPolygon2D

export var outline_color: Color = Color.black

func _ready() -> void:
    pass

func _draw() -> void:
    draw_polyline(polygon, outline_color, 2.0)