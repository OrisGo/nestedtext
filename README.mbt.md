# OrisGo/nestedtext

NestedText serialization format parser and emitter implemented in MoonBit.

> **Notice**: This project is a MoonBit port of the Rust [
ested-text](https://github.com/hansstimer/nested-text) crate. It inherits the Apache-2.0 OR MIT dual license.

## Introduction

This library brings support for the [NestedText](https://nestedtext.org/) serialization format—a human-readable data format focused on simplicity and ease of use—to the MoonBit ecosystem.

## Development Status

- [x] Minimal Value API and fail-fast loads entry point
- [x] Lexer (line classification, BOM stripping, newline normalization, indentation checks)
- [x] Parser (basic block dictionaries, lists, multiline strings, multiline keys, inline values)
- [x] Emitter (dumps, DumpOptions, render helpers)
- [x] Test suite integration (25 tests: 6 parsing + 17 serialization + 2 roundtrip)
- [x] Official compliance test suite: 173 tests passing as of 2026-06-20

## Usage

### Parse

`mbt
///|
test "parse a NestedText dictionary" {
  let input = "name: Alice\nage: 30"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(value)) => {
      assert_true(
        value ==
        @nestedtext.Value::Dict([
          ("name", @nestedtext.Value::String("Alice")),
          ("age", @nestedtext.Value::String("30")),
        ]),
      )
    }
    _ => fail("parse failed")
  }
}
`

### Serialize

`mbt
///|
test "serialize a Value to NestedText" {
  let value = @nestedtext.Value::Dict([
    ("name", @nestedtext.Value::String("Alice")),
    ("age", @nestedtext.Value::String("30")),
  ])
  let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(output, "name: Alice\nage: 30\n")
}
`

### Roundtrip

`mbt
///|
test "roundtrip: loads -> dumps -> loads" {
  let input = "name: Alice\nage: 30"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(value)) => {
      let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
      match @nestedtext.loads(output, @nestedtext.Top::Any) {
        Ok(Some(rv)) => assert_true(value == rv)
        _ => fail("roundtrip parse failed")
      }
    }
    _ => fail("parse failed")
  }
}
`

## TODO

- Port the official NestedText load tests from 	ests.json.
- Match official error message wording and line/column metadata case by case.
- Add serde-like deserialization adapter.
- Add CLI tool.

## License

This project is dually licensed under the MIT License and the Apache License, Version 2.0. See LICENSE, LICENSE-MIT, and LICENSE-APACHE for details.
