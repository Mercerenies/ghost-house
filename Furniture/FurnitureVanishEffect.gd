extends Node

var increase_in_alpha: float = 1.2
var decrease_in_alpha: float = 0.4

func _process(delta: float) -> void:
    var furn = get_parent()
    var distance = EnemyAI.distance_to_player(furn)
    var dir = EnemyAI.player_line_of_sight(furn)
    var distance_a = clamp((1 / 128.0) * (192 - distance), 0, 1)
    var dir_a = clamp((4.0 / PI) * (PI / 2.0 - dir), 0, 1)
    var target_a = round(max(distance_a, dir_a))
    var change_a = increase_in_alpha if furn.modulate.a < target_a else decrease_in_alpha
    furn.modulate.a = Util.toward(furn.modulate.a, change_a * delta, target_a)