extends Node

var _data: Dictionary = {}

func _ready():
    var file = File.new()
    file.open("res://AverageColors/average_colors.json", File.READ)
    var result = JSON.parse(file.get_as_text())
    if result.error == OK:
        _data = result.result
    else:
        print("Couldn't load average_colors.json")
        _data = {}
    file.close()

func get_color_by_name(name: String) -> Color:
    if name in _data:
        return Color(int(_data[name]))
    else:
        return Color.white

func get_color(object: Node) -> Color:
    return get_color_by_name(object.get_furniture_name())