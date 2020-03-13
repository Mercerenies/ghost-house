extends Reference
class_name FurnitureInteraction

# Abstract base class for the ways the player can interact with a
# furniture entity.

# Returns whether or not the interaction is active. If it doesn't make
# sense to perform this interaction, then is_active should return
# false, and the next interaction will be attempted. If you override
# this method, call the super method and return true only if the super
# method returns true AND all of the subclass conditions are also met.
func is_active() -> bool:
    return true

# Performs the specified interaction. As a precondition,
# implementations of this function may assume that the is_active
# conditions set forward by their class are true at the time this
# function is called.
func perform_interaction() -> void:
    pass
