extends Node2D

signal option_selected(option)

const ItemBox = preload("res://PauseMenu/ItemBox/ItemBox.tscn")

# TODO Spacing is a bit tight on some of the names (Invincible Potion
# comes to mind). Make more space.
const ITEM_BOX_PANE_WIDTH = 388
const ITEM_BOX_PANE_HEIGHT = 388
const ITEM_BOX_WIDTH = 64
const ITEM_BOX_HEIGHT = 96

var _rowlength: int = 0
var _option: int = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func _adjust_children_positions() -> void:
    for index in range($ItemList.get_child_count()):
        var box = $ItemList.get_child(index)
        # warning-ignore: integer_division
        var row: int = index / _rowlength
        var col: int = index % _rowlength

        var pos = Vector2(col * ITEM_BOX_WIDTH, row * ITEM_BOX_HEIGHT)
        box.position = pos

    # warning-ignore: integer_division
    var row: int = _option / _rowlength
    var col: int = _option % _rowlength
    $CurrentOption.position = $ItemList.position + Vector2(col * ITEM_BOX_WIDTH, row * ITEM_BOX_HEIGHT)

func refresh_data(reset_option: bool):
    var player_stats = get_room().get_player_stats()
    var items = player_stats.get_inventory().get_item_list()

    $Label.visible = (len(items) == 0)
    $CurrentOption.visible = (len(items) != 0)

    # warning-ignore: integer_division
    _rowlength = int(ITEM_BOX_PANE_WIDTH / ITEM_BOX_WIDTH)

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
        box.visible = ((ypos >= 0) and (ypos < ITEM_BOX_PANE_HEIGHT - ITEM_BOX_HEIGHT))
        $ItemList.add_child(box)
        xpos += ITEM_BOX_WIDTH
        if xpos > ITEM_BOX_PANE_WIDTH - ITEM_BOX_WIDTH:
            xpos = 0
            ypos += ITEM_BOX_HEIGHT # TODO Enable scrolling if there are too many items (/////)
            startindex = index

    if reset_option:
        set_option(0)
    else:
        # Just in case the bounds of the list have changed, make sure
        # the index is still valid.
        set_option(get_option())
    _update_self()

func _update_self():
    _adjust_children_positions()

func on_push() -> void:
    visible = true
    refresh_data(true)

func on_pop() -> void:
    visible = false

func _ready() -> void:
    visible = false
    refresh_data(true)

func get_option() -> int:
    return _option

func set_option(option: int) -> void:
    var items = get_room().get_player_stats().get_inventory().get_item_list()

    if len(items) != 0:
        option = int(clamp(option, 0, len(items) - 1))
        _option = option
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
            emit_signal("option_selected", get_option())
        "ui_cancel":
            get_pause_menu().pop_control()
    return true # Modal

func _on_ItemMenu_option_selected(option: int):
    var items = get_room().get_player_stats().get_inventory().get_item_list()
    if len(items) > 0:
        var item = items[option]
        $ItemPanel.set_item(item)
        get_pause_menu().push_control($ItemPanel)
