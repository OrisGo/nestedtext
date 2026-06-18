# OrisGo/nestedtext

NestedText serialization format parser and emitter implemented in MoonBit.

> **Notice**: This project is a MoonBit port of the Rust [`nested-text`](https://github.com/hansstimer/nested-text) crate. It inherits the Apache-2.0 OR MIT dual license.

## Introduction

This library brings support for the [NestedText](https://nestedtext.org/) serialization format—a human-readable data format focused on simplicity and ease of use—to the MoonBit ecosystem.

## Development Status

This project is currently in the early stages of development:

- [x] Minimal `Value` API and fail-fast `loads` entry point
- [x] Lexer (line classification, BOM stripping, newline normalization, indentation checks)
- [x] Parser (basic block dictionaries, lists, multiline strings, multiline keys, inline values)
- [ ] Emitter (Stringifier)
- [ ] Test suite integration

## Usage

```mbt check
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
      assert_true(value.get("name") == Some(@nestedtext.Value::String("Alice")))
    }
    other => fail("unexpected parse result: \{to_repr(other)}")
  }
}
```

## TODO

- Sync each implementation commit with executable examples in `README.mbt.md`.
- Port the official NestedText load tests from `tests.json`.
- Match official error message wording and line/column metadata case by case.
- Add `dumps` only after the loader behavior is pinned down by tests.

## License

This project is dually licensed under the MIT License and the Apache License, Version 2.0. See `LICENSE`, `LICENSE-MIT`, and `LICENSE-APACHE` for details.
