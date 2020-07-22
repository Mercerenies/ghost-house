extends StaticEntity

var _dialogue: Dictionary = {}

func generate_dialogue_given(filenames: Array) -> Dictionary:
    var options = []
    var d = {}
    var index = 0
    for filename in filenames:
        var state = "gstate{}".format([index], "{}")
        options.push_back({ "text": filename, "state": state })
        d[state] = [
            {
                "command": "action",
                "action": "spawn_mansion",
                "arg": filename
            }
        ]
        index += 1
    options.push_back({ "text": "None", "state": "end" })
    d["interact"] = [
        {
            "command": "branch",
            "text": "Which scenario would you like to attempt?",
            "options": options
        }
    ]
    d["end"] = []
    return d

func _ready() -> void:
    _dialogue = generate_dialogue_given(["res://DebugGeneratedRoom/test_standard.json",
                                        "res://DebugGeneratedRoom/test_minimal.json",
                                        "res://DebugGeneratedRoom/test_ghostparty.json"])

func on_interact() -> void:
    get_room().show_dialogue(_dialogue, "interact")
