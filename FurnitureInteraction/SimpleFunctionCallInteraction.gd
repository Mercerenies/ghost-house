extends FurnitureInteraction

var object
var method: String

func _init(object, method: String) -> void:
    self.object = object
    self.method = method

func perform_interaction() -> void:
    self.object.call(method)
