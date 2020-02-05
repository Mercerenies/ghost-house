extends Node2D

const Generator = preload("res://Generator/Generator.gd")

func _ready():
    randomize()

    var data = {}
    var file = File.new()
    file.open("res://DebugGeneratedRoom/test1.json", File.READ)
    var result = JSON.parse(file.get_as_text())
    if result.error == OK:
        data = result.result

    var gen = Generator.new(data)
    var room = gen.generate()
    add_child(room)

    # DEBUG CODE
    var fakeghost = preload("res://FakeGhost/FakeGhost.tscn").instance()
    fakeghost.position = Vector2(128, 128)
    room.get_node("Entities").add_child(fakeghost)
