#!/usr/bin/python3

# This is a wrapper around the jsonschema library
# (https://github.com/Julian/jsonschema) which overrides the library's
# usual remote loads with local ones, as I intend that my $ref schemas
# reference files in the same directory. Note that this Python script
# is *not* necessary to run the ghost-house game itself. This is a
# script I use for internal purposes to validate the JSON files and is
# not used in any way by the actual game.

import json
import sys
import os.path
from jsonschema import Draft7Validator, RefResolver

class LocalResolver(RefResolver):

    def __init__(self, base, schema):
        super().__init__("", "")
        self.base = base
        self.schema = schema

    def resolve(self, ref):
        inner = []
        if "#" in ref:
            ref, inner = ref.split("#")
            if ref == "":
                ref = self.resolution_scope.split("/")[-1]
            inner = inner.split("/")
        path = os.path.join(self.base, ref)
        with open(path) as f:
            schema = json.load(f)
        for inn in inner:
            if inn != "":
                schema = schema[inn]
        return ref, schema

if len(sys.argv) < 3:
    print("Usage: ./validate.py <schema> <target>", file=sys.stderr)
    exit(1)

schema_path = sys.argv[1]
target_path = sys.argv[2]

with open(schema_path) as f:
    schema = json.load(f)

with open(target_path) as f:
    target = json.load(f)

base = os.path.dirname(schema_path)

validator = Draft7Validator(schema, resolver=LocalResolver(base, schema))
validator.validate(target, schema)
