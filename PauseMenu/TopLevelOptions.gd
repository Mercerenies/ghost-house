extends Node

const TOP_LEVEL_OPTIONS = ["Player Status", "Example Option 1", "Example Option 2", "Example Option 3", "Back to Game"]

func _on_TopLevelPauseMenu_option_selected(option: String):
    match option:
        "Player Status":
            get_parent().push_control(get_node("../PlayerStatus"))
        "Back to Game":
            get_parent().unpause()
