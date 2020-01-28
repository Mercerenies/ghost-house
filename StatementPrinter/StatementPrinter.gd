extends Node

# Note: This file does nontrivial logic translations to make
# statements as pretty as possible. We NEED to update this file when
# we change the puzzle.json format to allow additional statement
# types. There are no catch-alls. It enumerates the possible values.

func is_simple_positive(s) -> bool:
    if s is Dictionary and s['op'] == "atomic":
        return true
    return false

func is_simple_negative(s) -> bool:
    if s is Dictionary and s['op'] == "not":
        return is_simple_positive(s['target'])
    return false

func extract_name(s):
    if is_simple_positive(s):
        return s['name']
    if is_simple_negative(s):
        return extract_name(s['target'])
    return null

func extract_query(s):
    if is_simple_positive(s):
        return s['query']
    if is_simple_negative(s):
        return extract_query(s['target'])
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

# Returns { orientation: true | false, query: query_name } on success, null on failure
func _all_match(arr: Array):
    if len(arr) == 0:
        return { "orientation": true, "query": "truth" }
    var query = null
    var orientation = null
    for v in arr:
        if is_simple_positive(v):
            if orientation != null and orientation != true:
                return null
            if query != null and query != extract_query(v):
                return null
            orientation = true
            query = extract_query(v)
        elif is_simple_negative(v):
            if orientation != null and orientation != false:
                return null
            if query != null and query != extract_query(v):
                return null
            orientation = false
            query = extract_query(v)
        else:
            return null
    return { "orientation": orientation, "query": query }

func _batch_rename(s, obj, funcname):
    match s['op']:
        'atomic':
            s['name'] = obj.call(funcname, s['name'])
        'not':
            s['target'] = _batch_rename(s['target'], obj, funcname)
        'and', 'or':
            for i in range(len(s['target'])):
                s['target'][i] = _batch_rename(s['target'][i], obj, funcname)
    return s

# Accepts any valid argument to translate(). The function should take
# one argument (a string) and return the new name. A new JSON datum is
# returned, with structure identical to the first except that names
# have been altered.
func batch_rename(s, obj, funcname):
    assert(s is Dictionary or s is String)
    var s1 = Util.deep_copy(s)
    return _batch_rename(s1, obj, funcname)

func translate(s) -> String:

    assert(s is Dictionary or s is String)

    # Simple positive
    if is_simple_positive(s):
        match extract_query(s):
            "truth":
                return "{0} is telling the truth".format([extract_name(s)])

    # Simple negative
    if is_simple_negative(s):
        match extract_query(s):
            "truth":
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
        var result = _all_match(s['target'])
        if result["orientation"] != null:
            var names = Util.map(self, "extract_name", s['target'])
            match result["query"]:
                "truth":
                    if result["orientation"]:
                        return "{0} are all telling the truth".format([comma_list(names, "and")])
                    else:
                        return "{0} are all lying".format([comma_list(names, "and")])

    # OR-const compound
    if s['op'] == "or":
        var result = _all_match(s['target'])
        if result["orientation"] != null:
            var names = Util.map(self, "extract_name", s['target'])
            match result["query"]:
                "truth":
                    if result["orientation"]:
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
