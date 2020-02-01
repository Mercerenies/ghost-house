extends Node

const TOP_LEVEL_OPTIONS = ["Player Status", "Known Clues", "Example Option 1", "Example Option 2", "Example Option 3", "Example Option 4", "Example Option 5", "Example Option 6", "Back to Game"]

func _on_TopLevelPauseMenu_option_selected(option: String):
    match option:
        "Player Status":
            get_parent().push_control(get_node("../PlayerStatus"))
        "Known Clues":
            get_parent().push_control(get_node("../KnownCluesList"))
        "Back to Game":
            get_parent().unpause()
