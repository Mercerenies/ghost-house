extends Node2D

signal option_selected(option)

const ItemBox = preload("res://PauseMenu/ItemBox/ItemBox.tscn")

# TODO Spacing is a bit tight on some of the names (Invincible Potion
# comes to mind). Make more space.
const ITEM_BOX_PANE_WIDTH = 388
const ITEM_BOX_PANE_HEIGHT = 388
const ITEM_BOX_WIDTH = 64
const ITEM_BOX_HEIGHT = 96

var _option: int = 0

func get_pause_menu():
    return get_parent()

func get_room():
    return get_pause_menu().get_room()

func determine_row_length() -> int:
    # warning-ignore: integer_division
    return ITEM_BOX_PANE_WIDTH / ITEM_BOX_WIDTH

func determine_column_length() -> int:
    # warning-ignore: integer_division
    return ITEM_BOX_PANE_HEIGHT / ITEM_BOX_HEIGHT

func _adjust_children_positions() -> void:
    var items = get_room().get_player_stats().get_inventory().get_item_list()
    var rowlength = determine_row_length()

    # warning-ignore: integer_division
    var selected_row = _option / rowlength
    var onscreen_rowcount = determine_column_length()
    var total_rowcount = ceil(float(len(items)) / rowlength) as int

    var yoffset_entries = selected_row - int(onscreen_rowcount / 2)
    yoffset_entries = int(clamp(yoffset_entries, 0, total_rowcount - onscreen_rowcount))
    var offset = Vector2(0, - yoffset_entries * ITEM_BOX_HEIGHT)

    $UpArrowSprite.visible = (yoffset_entries > 0)
    $DownArrowSprite.visible = (yoffset_entries < total_rowcount - onscreen_rowcount)

    for index in range($ItemList.get_child_count()):
        var box = $ItemList.get_child(index)
        # warning-ignore: integer_division
        var row: int = index / rowlength
        var col: int = index % rowlength

        var pos = offset + Vector2(col * ITEM_BOX_WIDTH, row * ITEM_BOX_HEIGHT)
        box.position = pos
        box.visible = ((pos.y >= 0) and (pos.y < ITEM_BOX_PANE_HEIGHT - ITEM_BOX_HEIGHT))

    # warning-ignore: integer_division
    var row: int = _option / rowlength
    var col: int = _option % rowlength
    $CurrentOption.position = $ItemList.position + offset + Vector2(col * ITEM_BOX_WIDTH, row * ITEM_BOX_HEIGHT)

func refresh_data(reset_option: bool):
    var player_stats = get_room().get_player_stats()
    var items = player_stats.get_inventory().get_item_list()

    for _i in range($ItemList.get_child_count()):
        var box = $ItemList.get_child(0)
        $ItemList.remove_child(box)
        box.queue_free()

    $Label.visible = (len(items) == 0)
    $CurrentOption.visible = (len(items) != 0)

    for item in items:
        var box = ItemBox.instance()
        box.set_item(item)
        $ItemList.add_child(box)

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
    var rowlength = determine_row_length()
    match input_type:
        "ui_down":
            set_option(get_option() + rowlength)
        "ui_up":
            set_option(get_option() - rowlength)
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
