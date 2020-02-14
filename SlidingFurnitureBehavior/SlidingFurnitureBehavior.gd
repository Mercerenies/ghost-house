extends Node2D

func get_furniture() -> StaticEntity:
    return get_parent() as StaticEntity

func get_room():
    return get_furniture().get_room()

func _ready() -> void:
    pass

func activate() -> void:
    var player = EnemyAI.get_player(self)
    if player != null and not player.is_connected("player_moved", self, "_on_Player_player_moved"):
        player.connect("player_moved", self, "_on_Player_player_moved")

func deactivate() -> void:
    var player = EnemyAI.get_player(self)
    if player != null and player.is_connected("player_moved", self, "_on_Player_player_moved"):
        player.disconnect("player_moved", self, "_on_Player_player_moved")

func _on_Player_player_moved() -> void:
    pass
