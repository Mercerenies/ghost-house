extends Node

enum GhostColor {
    Red, Green, Blue, Yellow, Pink
}

func color_constant_to_color(value: int) -> Color:
    match value:
        GhostColor.Red:
            return Color(0xFF7777FF)
        GhostColor.Green:
            return Color(0x48B744FF)
        GhostColor.Blue:
            return Color(0x4B7FD8FF)
        GhostColor.Yellow:
            return Color(0xEBFC21FF)
        GhostColor.Pink:
            return Color(0xF946C8FF)
    return Color.white # TODO Appropriate default value?

func color_constant_to_string(value: int) -> String:
    match value:
        GhostColor.Red:
            return "Red"
        GhostColor.Green:
            return "Green"
        GhostColor.Blue:
            return "Blue"
        GhostColor.Yellow:
            return "Yellow"
        GhostColor.Pink:
            return "Pink"
    return "???"

func color_constants() -> Array:
    return [GhostColor.Red, GhostColor.Green, GhostColor.Blue, GhostColor.Yellow, GhostColor.Pink]
