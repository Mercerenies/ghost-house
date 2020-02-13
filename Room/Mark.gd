extends Node
class_name Mark

# Constants for use in the marked_entities dictionary of a room. Any
# string is a valid key in that dictionary, but for consistency the
# marks used are stored here as constants. Note that you should
# *never* assume these keys exist in the dictionary. In particular,
# the dictionary starts out empty, so if there are no nodes of that
# particular type, the key will not have been placed in the
# marked_entities dictionary yet. Always check or assert before
# accessing.

# The player, a single node, is stored at the mark PLAYER
const PLAYER = 'player'

# All Shadow Stalkers, as an array, are stored at SHADOW_STALKER
const SHADOW_STALKER = 'shadow_stalker'
