extends Node
class_name ItemTag

enum {
    # Essential items are potential blockers for completion of the
    # floor.
    ESSENTIAL = 150,
    # Short-term items, such as potions, have effects that, when
    # activated, last a short period of time.
    SHORT_TERM = 151,
    # Long-term items have effects that, when activated, last for the
    # rest of the current mansion.
    LONG_TERM = 152,
    # Debug items are, as the name implies, intended for debug use
    # only and should not appear in-game in production.
    DEBUG = 153,
}
