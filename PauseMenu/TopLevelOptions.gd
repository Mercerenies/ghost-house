extends Node

enum Option {
    PlayerStatus = 0,
    KnownClues = 1,
    ItemMenu = 2,
    DebugMenu = 3,
    BackToGame = 4,
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
        Option.BackToGame:
            get_parent().unpause()
