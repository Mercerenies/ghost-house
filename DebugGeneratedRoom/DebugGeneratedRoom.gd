extends Node2D

func _ready():
    randomize()
    var gen = Generator.new({ 'config': { 'width': 12, 'height': 12 } })
    var room = gen.generate()
    gen.free()
    add_child(room)
