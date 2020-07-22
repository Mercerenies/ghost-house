extends Node

enum Option {
    PlayerStatus = 0,
    KnownClues = 1,
    ItemMenu = 2,
    DebugMenu = 3,
    ForfeitCase = 4,
    BackToGame = 5,
    Example1 = 1001,
    Example2 = 1002,
    Example3 = 1003,
    Example4 = 1004,
    Example5 = 1005,
    Example6 = 1006,
}

const TOP_LEVEL_OPTIONS = [
    { "id": Option.PlayerStatus, "text": "Player Status" },
    { "id": Option.KnownClues, "text": "Known Clues" },
    { "id": Option.ItemMenu, "text": "Items" },
    { "id": Option.DebugMenu, "text": "Debug Menu" },
    { "id": Option.Example1, "text": "Example Option 1" },
    { "id": Option.Example2, "text": "Example Option 2" },
    { "id": Option.Example3, "text": "Example Option 3" },
    { "id": Option.Example4, "text": "Example Option 4" },
    { "id": Option.Example5, "text": "Example Option 5" },
    { "id": Option.Example6, "text": "Example Option 6" },
    { "id": Option.ForfeitCase, "text": "Forfeit Case" },
    { "id": Option.BackToGame, "text": "Back to Game" }
]

func _on_TopLevelPauseMenu_option_selected(option: int):
    match option:
        Option.PlayerStatus:
            get_parent().push_control(get_node("../PlayerStatus"))
        Option.KnownClues:
            get_parent().push_control(get_node("../KnownCluesList"))
        Option.ItemMenu:
            get_parent().push_control(get_node("../ItemMenu"))
        Option.DebugMenu:
            get_parent().push_control(get_node("../DebugMenu"))
        Option.ForfeitCase:
            get_parent().push_control(get_node("../ForfeitConfirmBox"))
        Option.BackToGame:
            get_parent().unpause()

func _on_ForfeitConfirmBox_option_selected(option: int):
    var box = get_node("../ForfeitConfirmBox")
    match option:
        box.OPTION_NO:
            get_parent().pop_control()
        box.OPTION_YES:
            get_parent().pop_control()
            # TODO Animate this?
            var OverworldRoom = load("res://OverworldRoom/OverworldRoom.tscn")
            var room = OverworldRoom.instance()
            get_tree().get_root().add_child(room)
            get_tree().get_current_scene().queue_free()
            get_tree().set_current_scene(room)
            get_parent().unpause()
