extends Node2D

signal option_selected(option)

const ItemBox = preload("res://PauseMenu/ItemBox/ItemBox.tscn")

const ITEM_BOX_PANE_WIDTH = 388
const ITEM_BOX_WIDTH = 64
const ITEM_BOX_HEIGHT = 96

var _rowlength: int = 0
var _option: int = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func _reset_self():
    var player_stats = get_room().get_player_stats()
    var items = player_stats.get_inventory().get_item_list()

    $Label.visible = (len(items) == 0)
    $CurrentOption.visible = (len(items) != 0)

    _rowlength = 0

    for box in $ItemList.get_children():
        box.queue_free()
    var xpos = 0
    var ypos = 0
    var startindex = -1
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
            startindex = index
    _rowlength = max(_rowlength, (len(items) - 1) - startindex)

    set_option(0)
    _update_self()

func _update_self():
    pass # Does nothing right now

func on_push() -> void:
    visible = true
    _reset_self()

func on_pop() -> void:
    visible = false

func _ready() -> void:
    visible = false
    _reset_self()

func get_option() -> int:
    return _option

func set_option(option: int) -> void:
    var items = get_room().get_player_stats().get_inventory().get_item_list()

    if len(items) != 0 and option >= 0 and option < len(items):
        _option = option
        var xindex = _option % _rowlength
        var yindex = int(_option / _rowlength)
        $CurrentOption.position = $ItemList.position + Vector2(xindex * ITEM_BOX_WIDTH, yindex * ITEM_BOX_HEIGHT)
    _update_self()

func handle_input(input_type: String) -> bool:
    match input_type:
        "ui_down":
            set_option(get_option() + _rowlength)
        "ui_up":
            set_option(get_option() - _rowlength)
        "ui_left":
            set_option(get_option() - 1)
        "ui_right":
            set_option(get_option() + 1)
        "ui_accept":
            var items = get_room().get_player_stats().get_inventory().get_item_list()
            if len(items) > 0:
                var item = items[get_option()]
                $ItemPanel.set_item(item)
                get_pause_menu().push_control($ItemPanel)
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal
