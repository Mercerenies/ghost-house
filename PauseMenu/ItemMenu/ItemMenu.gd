extends Node2D

signal option_selected(option)

const ItemBox = preload("res://PauseMenu/ItemBox/ItemBox.tscn")

const ITEM_BOX_PANE_WIDTH = 452
const ITEM_BOX_WIDTH = 64
const ITEM_BOX_HEIGHT = 96

var _rowlength: int = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func _update_self():
    var player_stats = get_room().get_player_stats()
    var items = player_stats.get_inventory().get_item_list()

    _rowlength = 0

    for box in $ItemList.get_children():
        box.queue_free()
    var xpos = 0
    var ypos = 0
    var startindex = 0
    for index in range(len(items)):
        var item = items[index]
        var box = ItemBox.instance()
        box.set_item(item)
        box.position = Vector2(xpos, ypos)
        $ItemList.add_child(box)
        xpos += ITEM_BOX_WIDTH
        if xpos > ITEM_BOX_PANE_WIDTH - ITEM_BOX_WIDTH:
            xpos = 0
            ypos += ITEM_BOX_HEIGHT # TODO Enable scrolling if there are too many items
            _rowlength = max(_rowlength, index - startindex)

func on_push() -> void:
    visible = true
    _update_self()

func on_pop() -> void:
    visible = false

func _ready() -> void:
    visible = false
    _update_self()

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down":
            pass
        "ui_up":
            pass
        "ui_accept":
            pass
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal
