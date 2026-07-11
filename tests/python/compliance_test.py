"""
Compliance tests migrated from compliance_test.mbt to Python.

Tests the NestedText format compliance for deeply nested structures
that would cause OOM during `moon fmt` in the original MoonBit test file.
"""

import nestedtext as nt


def build_deep_dict(letters: list[str]):
    """
    Build the expected deeply nested structure.

    Pattern: {"letter1": [{"letter2": [...{"letterN": [""]}]}]}

    The leaf is always [""] — a list containing an empty string.
    """
    current = ""
    for letter in reversed(letters):
        current = {letter: [current]}
    return current


def test_spillage():
    """
    Test deeply nested dict/list via multi-line NestedText.

    Original MoonBit test: "compliance: spillage"
    Structure: a -> [b -> [c -> [...] -> [omega -> [""]]]]
    """
    letters = list("abcdefghijklmnopqrstuvwxyz") + list(
        "\u03b1\u03b2\u03b3\u03b4\u03b5\u03b6\u03b7\u03b8\u03b9\u03ba\u03bb\u03bc\u03bd\u03be\u03bf\u03c0\u03c1\u03c3\u03c4\u03c5\u03c6\u03c7\u03c8\u03c9"
    )

    lines = ["a:"]
    indent = 1
    for letter in letters[1:]:
        lines.append(" " * indent + "-")
        indent += 1
        lines.append(" " * indent + letter + ":")
        indent += 1
    lines.append(" " * indent + "-")
    input_str = "\n".join(lines)

    result = nt.loads(input_str)
    expected = build_deep_dict(letters)

    assert result == expected, "Spillage mismatch"


def test_moccasin():
    """
    Test deeply nested dict/list via inline NestedText.

    Original MoonBit test: "compliance: moccasin"
    Structure: {a:[{b:[{c:[...{z:[]}...]}]}]}
    """
    letters = list("abcdefghijklmnopqrstuvwxyz")

    parts = []
    for letter in letters:
        parts.append(letter + ":[")
        if letter != letters[-1]:
            parts.append("{")
    parts.append(" ")
    parts.append("]}" * len(letters))
    input_str = "{" + "".join(parts)

    result = nt.loads(input_str)
    expected = build_deep_dict(letters)

    assert result == expected, "Moccasin mismatch"


if __name__ == "__main__":
    test_spillage()
    test_moccasin()
    print("All compliance tests passed.")
