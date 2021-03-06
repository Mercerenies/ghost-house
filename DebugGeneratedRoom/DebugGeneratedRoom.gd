extends Node2D

const Generator = preload("res://Generator/Generator.gd")

func _ready():
    randomize()

    var data = {}
    var file = File.new()
    file.open("res://DebugGeneratedRoom/test_standard.json", File.READ)
    var result = JSON.parse(file.get_as_text())
    file.close();
    if result.error == OK:
        data = result.result

    var gen = Generator.new(data)
    var room = gen.generate()
    add_child(room)
