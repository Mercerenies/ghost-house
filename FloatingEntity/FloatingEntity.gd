extends Entity
class_name FloatingEntity

# Common superclass for nodes that exist in the entity layer but do
# not take up grid cells.

func position_self() -> void:
    pass

func unposition_self() -> void:
    pass
