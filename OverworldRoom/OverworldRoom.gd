extends Node2D

const MansionRoom = preload("res://MansionRoom/MansionRoom.gd")

func _ready() -> void:
    $Room.get_marked_entities()[Mark.PLAYER] = $Room/Entities/Player

func _on_DialogueBox_do_action(action, arg):
    match action:
        "noop":
            pass
        "spawn_mansion":
            $Room/CanvasLayer/DialogueBox._end_conversation()
            var data = JSONData.wrap(arg)
            var mroom = MansionRoom.new(data)
            # TODO Do we actually want to change the entire root? Not
            # just replace some controlled root's child?
            get_tree().get_root().add_child(mroom)
            get_tree().set_current_scene(mroom)
            self.queue_free()
