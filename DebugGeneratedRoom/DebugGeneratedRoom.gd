extends Node2D

func _ready():
    randomize()
    var gen = Generator.new({ 'config': { 'width': 10, 'height': 10 } })
    var room = gen.generate()
    gen.free()
    add_child(room)
