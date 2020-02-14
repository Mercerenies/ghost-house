extends Node2D

# ///// Need to think about the infrastructure for this, because it's
# different from FlyingFurniture in a nontrivial way (namely, it needs
# to be able to position itself in the grid when not moving)

const SlidingFurniture = preload("res://SlidingFurniture/SlidingFurniture.tscn")

const RESPAWN_DISTANCE: float = 512.0
