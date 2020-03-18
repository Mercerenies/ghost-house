extends Reference
class_name Collectible

# NOTE: Collectible instances should always be immutable after
# construction. This is to ensure that they can be shared safely
# across multiple articles of furniture. Mutating a Collectible after
# construction may result in undefined behavior.

func get_tags() -> Array:
    return []

# Returns whether successful
func perform_collection(_furniture) -> bool:
    return false
