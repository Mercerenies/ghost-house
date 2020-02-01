extends Node

const TOP_LEVEL_OPTIONS = ["Example Option 1", "Example Option 2", "Example Option 3", "Back to Game"]

func _on_TopLevelPauseMenu_option_selected(option: String):
    match option:
        "Back to Game":
            get_parent().unpause()
