extends Node

# Note: This file does nontrivial logic translations to make
# statements as pretty as possible. We NEED to update this file when
# we change the puzzle.json format to allow additional statement
# types. There are no catch-alls. It enumerates the possible values.

func is_simple_positive(s) -> bool:
    return s is String

func is_simple_negative(s) -> bool:
    if s is Dictionary and s['op'] == "not":
        return is_simple_positive(s['target'])
    return false

func extract_name(s):
    if is_simple_positive(s):
        return s
    if is_simple_negative(s):
        return s['target']
    return null

func comma_list(arr: Array, conj: String = "and") -> String:
    match len(arr):
        0:
            return ""
        1:
            return arr[0]
        2:
            return "{0} {c} {1}".format({ 0: arr[0], "c": conj, 1: arr[1] })
        _:
            var s = ""
            for i in range(len(arr) - 1):
                s += arr[i] + ", "
            s += conj + " " + arr[len(arr) - 1]
            return s

# Returns true or false for matching orientation (of true or false,
# resp.). Returns null on failure.
func _all_match(arr: Array):
    if len(arr) == 0:
        return true # True or false would be acceptable here; it's a
                    # trivial result.
    var orientation = null
    for v in arr:
        if is_simple_positive(v):
            if orientation == false:
                return null
            orientation = true
        elif is_simple_negative(v):
            if orientation == true:
                return null
            orientation = false
        else:
            return null
    return orientation

func translate(s) -> String:

    assert(s is Dictionary or s is String);

    # Simple positive
    if is_simple_positive(s):
        return "{0} is telling the truth".format([extract_name(s)])

    # Simple negative
    if is_simple_negative(s):
        return "{0} is lying".format([extract_name(s)])

    # Trivial logical ops
    if s['op'] == "and" and len(s['target']) == 0:
        return "(true)"
    if s['op'] == "or" and len(s['target']) == 0:
        return "(false)"
    if (s['op'] == "and" or s['op'] == "or") and len(s['target']) == 1:
        return translate(s['target'][0])
    if s['op'] == "not" and s['target'] is Dictionary and s['target']['op'] == "not":
        return translate(s['target']['target'])

    # NOT-OR: Distribute
    if s['op'] == "not" and s['op'] == "or":
        var arr = []
        for v in s['target']:
            arr.append({ "op": "not", "target": v })
        var s1 = { "op": "and", "target": arr }
        return translate(s1)

    # NOT-AND: Distribute
    if s['op'] == "not" and s['op'] == "and":
        var arr = []
        for v in s['target']:
            arr.append({ "op": "not", "target": v })
        var s1 = { "op": "or", "target": arr }
        return translate(s1)

    # AND-const compound
    if s['op'] == "and":
        var orientation = _all_match(s['target'])
        if not (orientation == null):
            var names = Util.map(self, "extract_name", s['target'])
            if orientation:
                return "{0} are all telling the truth".format([comma_list(names, "and")])
            else:
                return "{0} are all lying".format([comma_list(names, "and")])

    # OR-const compound
    if s['op'] == "or":
        var orientation = _all_match(s['target'])
        if not (orientation == null):
            var names = Util.map(self, "extract_name", s['target'])
            if orientation:
                return "At least one of {0} is telling the truth".format([comma_list(names, "or")])
            else:
                return "At least one of {0} is lying".format([comma_list(names, "or")])

    # Generic AND
    if s['op'] == "and":
        var translated = Util.map(self, "translate", s['target'])
        return comma_list(translated, "and")

    # Generic OR
    if s['op'] == "or":
        var translated = Util.map(self, "translate", s['target'])
        return comma_list(translated, "or")

    # God, I hope this is exhaustive. If not, oops!
    assert(false)
    return "" # Type safety (??)
