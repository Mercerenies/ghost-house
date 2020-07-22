extends Node2D

func _ready() -> void:
    $Room.get_marked_entities()[Mark.PLAYER] = $Room/Entities/Player
