# OrisGo/nestedtext

[中文](README_zh.mbt.md)

NestedText serialization format parser, emitter, and typed deserialization adapter implemented in MoonBit.

> **Notice**: This project is a MoonBit port of the Rust [nested-text](https://github.com/hansstimer/nested-text) crate. It inherits the Apache-2.0 OR MIT dual license.

_NestedText_ is a human-readable data format focused on simplicity and ease of use. See [nestedtext.org](https://nestedtext.org/) for the specification.

> **Spec version**: this parser targets **NestedText v3.8** (released 2025-12-26). Compliance tests are adapted from the [official test suite](https://github.com/KenKundert/nestedtext_tests) (v3.8).

## Quick Start

### As a library

```bash
moon add OrisGo/nestedtext
```

```mbt check
///|
test "quick start" {
  match @nestedtext.loads("name: Alice\nage: 30", @nestedtext.Top::Any) {
    Ok(Some(v)) =>
      println(@nestedtext.dumps(v, @nestedtext.DumpOptions::default()))
    Ok(None) => println("(empty)")
    Err(e) => println("error: \{e.to_string()}")
  }
}
```

The library accepts `String` input. Read a `.nt` file first and pass its content to `loads`:

```mbt nocheck
let content = @fs.read_file_to_string("config.nt") catch {
  IOError(msg) => { println(msg); return }
}
match @nestedtext.loads(content, @nestedtext.Top::Any) {
  Ok(Some(v)) => { /* use v */ }
  Err(e) => println(e.to_string())
}
```

> `moonbitlang/core` does not yet include a stable `@fs` module. See [File I/O](#file-io) for options.

### As a CLI tool

```bash
moon run cmd/main -- examples/config.nt
```

```
=== examples/config.nt ===
PASS | 8 lines | 5ms | -> examples/config.nt.out
```

Restrict the top-level shape via environment variable:

```bash
$env:NESTEDTEXT_TOP = "list"; moon run cmd/main -- examples/data.nt
```

## File I/O

The `@nestedtext` library itself depends only on `moonbitlang/core` (stable). It does **not** import file I/O packages, so your own project stays in control of how files are read.

Options for reading `.nt` files:

| Approach | Status | Recommendation |
|----------|--------|----------------|
| `moonbitlang/x/fs` | Experimental (`moonbitlang/x` v0.4.x) | Use today — works on native target |
| `moonbitlang/core/fs` | Planned (beta-preview, ~Aug 2026) | Wait for stable release |
| External language (Python, etc.) | Always available | Bridge via subprocess or FFI |

If you use `moonbitlang/x/fs`, add it to your **application** `moon.pkg` (not to the library):

```mbt nocheck
///|
import {
  "OrisGo/nestedtext",
  "moonbitlang/x/fs",
}
```

Then read and parse:

```mbt nocheck
let content = @fs.read_file_to_string("data.nt") catch {
  IOError(msg) => { println(msg); return }
}
match @nestedtext.loads(content, @nestedtext.Top::Any) {
  Ok(Some(v)) => println(@nestedtext.dumps(v, @nestedtext.DumpOptions::default()))
  Err(e) => println(e.to_string())
}
```

The bundled CLI (`cmd/main`) uses `moonbitlang/x/fs` as a reference implementation. Once `@fs` lands in core, the CLI will switch to it and a convenience `read_file` helper may be added to the library.

## Parsing

Use `loads` to parse a NestedText document into a `Value` tree. Pass a `Top` constraint to validate the top-level shape.

```mbt check
///|
test "parse dictionary" {
  let input = "name: Alice\nage: 30"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(@nestedtext.Value::Dict(pairs))) => {
      @debug.assert_eq(pairs[0], ("name", @nestedtext.Value::String("Alice")))
      @debug.assert_eq(pairs[1], ("age", @nestedtext.Value::String("30")))
    }
    _ => fail("unexpected result")
  }
}

///|
test "parse nested list" {
  let input = "fruits:\n  - apple\n  - banana"
  match @nestedtext.loads(input, @nestedtext.Top::Dict) {
    Ok(Some(@nestedtext.Value::Dict(pairs))) => {
      @debug.assert_eq(pairs[0].0, "fruits")
      let expected = @nestedtext.Value::List([
        @nestedtext.Value::String("apple"),
        @nestedtext.Value::String("banana"),
      ])
      @debug.assert_eq(pairs[0].1, expected)
    }
    _ => fail("unexpected result")
  }
}
```

`Value` has three variants:

| Variant | Represents |
|---------|-----------|
| `String(String)` | A scalar string value |
| `List(Array[Value])` | An ordered list |
| `Dict(Array[(String, Value)])` | Name-value pairs in insertion order |

## Serializing

Use `dumps` to serialize a `Value` back to NestedText format.

```mbt check
///|
test "serialize to nestedtext" {
  let value = @nestedtext.Value::Dict([
    ("name", @nestedtext.Value::String("Alice")),
    ("age", @nestedtext.Value::String("30")),
  ])
  let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  @debug.assert_eq(output, "name: Alice\nage: 30\n")
}

///|
test "serialize with sorted keys" {
  let value = @nestedtext.Value::Dict([
    ("z", @nestedtext.Value::String("last")),
    ("a", @nestedtext.Value::String("first")),
  ])
  let opts = @nestedtext.DumpOptions::{ indent: 4, sort_keys: true, }
  @debug.assert_eq(@nestedtext.dumps(value, opts), "a: first\nz: last\n")
}

///|
test "roundtrip" {
  let input = "name: Alice\nage: 30"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(value)) => {
      let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
      match @nestedtext.loads(output, @nestedtext.Top::Any) {
        Ok(Some(rv)) => @debug.assert_eq(value, rv)
        _ => fail("roundtrip parse failed")
      }
    }
    _ => fail("initial parse failed")
  }
}
```

## Typed Deserialization

The `Deserializer` provides typed extraction on top of `Value` — similar in spirit to Rust's [serde](https://serde.rs/). Use `deserialize_str` to parse and deserialize in one step, or `deserialize_value` on an already-parsed `Value`.

### Comparison with Rust's serde

Unlike serde, this library does **not** use traits or derive macros. Instead, deserialization is driven by **higher-order functions**: you supply a closure `fn(Deserializer) -> Result[T, DeserializeError]` that calls typed extraction methods to build your target type.

| Aspect | Rust serde | OrisGo/nestedtext |
|--------|-----------|-------------------|
| Mechanism | `Deserialize` trait + `#[derive(Deserialize)]` | Callback closure `fn(Deserializer) -> Result[T, _]` |
| Struct deserialization | Automatic via derive | Manual via `get_field` + `expect_*` |
| Visitor pattern | `Visitor` trait with `visit_*` methods | Direct method calls on `Deserializer` |
| Error propagation | `serde::de::Error` trait | `Result[T, DeserializeError]` chaining with `try` |
| Input format | Generic data model | NestedText AST only (`Value` enum) |
| All values are strings | N/A (format-dependent) | Yes — `expect_int()` etc. parse from `Value::String` |

### Usage

```mbt check
///|
test "deserialize typed struct" {
  fn person(
    d : @nestedtext.Deserializer,
  ) -> Result[(String, Int32), @nestedtext.DeserializeError] {
    match d.get_field("name") {
      Ok(nd) =>
        match nd.expect_string() {
          Ok(name) =>
            match d.get_field("age") {
              Ok(ad) =>
                match ad.expect_int() {
                  Ok(age) => Ok((name, age))
                  Err(e) => Err(e)
                }
              Err(e) => Err(e)
            }
          Err(e) => Err(e)
        }
      Err(e) => Err(e)
    }
  }
  let input = "name: Alice\nage: 30"
  match @nestedtext.deserialize_str(input, @nestedtext.Top::Any, person) {
    Ok((name, age)) => {
      @debug.assert_eq(name, "Alice")
      @debug.assert_eq(age, 30)
    }
    Err(e) => fail(e.to_string())
  }
}

///|
test "deserialize list of ints" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::List([
      @nestedtext.Value::String("1"),
      @nestedtext.Value::String("2"),
      @nestedtext.Value::String("3"),
    ]),
  )
  match @nestedtext.deserialize_list(d, fn(d2) { d2.expect_int() }) {
    Ok(ints) => @debug.assert_eq(ints, [1, 2, 3])
    Err(_) => fail("unexpected error")
  }
}

///|
test "deserialize optional field" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String(""))
  match d.expect_optional(fn(d2) { d2.expect_int() }) {
    Ok(None) => ()
    _ => fail("expected None")
  }
}
```

`Deserializer` extraction methods:

| Method | Target Type | Notes |
|--------|------------|-------|
| `expect_string()` | `String` | Identity extraction |
| `expect_int()` | `Int32` | Parses decimal representation |
| `expect_int64()` | `Int64` | Parses decimal representation |
| `expect_double()` | `Double` | Parses decimal representation |
| `expect_bool()` | `Bool` | Accepts `true`/`True`/`TRUE`/`yes`/`Yes`/`YES` (and `false`/`no` equivalents) |
| `expect_list()` | `Array[Value]` | Raw list items |
| `expect_dict()` | `Array[(String, Value)]` | Raw dictionary pairs |
| `get_field(key)` | `Deserializer` | Look up a single field |
| `expect_optional(f)` | `T?` | `""` → `None`, otherwise → `Some(f(d))` |
| `has_field(key)` | `Bool` | Check key existence |
| `field_names()` | `Array[String]` | All keys in the dictionary |

## Error Handling

Parse errors carry location metadata (line number, column, source line).

```mbt check
///|
test "error location" {
  match @nestedtext.loads("key: value", @nestedtext.Top::Any) {
    Ok(value) =>
      match
        @nestedtext.deserialize_value(value.unwrap(), fn(d) { d.expect_int() }) {
        Err(e) => @debug.assert_eq(e.message, "expected string, got dictionary")
        Ok(_) => fail("expected error")
      }
    Err(e) => fail(e.to_string())
  }
}

///|
test "parse error with location" {
  match @nestedtext.loads("  key: value", @nestedtext.Top::Any) {
    Err(err) => {
      @debug.assert_eq(err.message, "top-level content must start in column 1.")
      assert_true(err.lineno == Some(1))
    }
    Ok(_) => fail("expected error")
  }
}
```

## Important: Encoding

NestedText documents must be valid UTF-8. The `loads` function takes a `String`, which in MoonBit is always UTF-8 encoded. Binary data containing invalid UTF-8 byte sequences will have those bytes replaced with the replacement character (`U+FFFD`), and `loads` returns an error indicating the location of the first replacement character.


**Known issue**: `moon fmt` may **time out** on `compliance_test.mbt`. The file is ~3200 lines with deeply nested literal expressions.

<!-- ## Development Status

- [x] Minimal Value API and fail-fast loads entry point
- [x] Lexer (line classification, BOM stripping, newline normalization, indentation checks)
- [x] Parser (basic block dictionaries, lists, multiline strings, multiline keys, inline values)
- [x] Emitter (dumps, DumpOptions, render helpers)
- [x] Official compliance test suite (v3.8): 148 tests (146 in `compliance_test.mbt` + 2 deep-nesting cases in Python)
- [x] Error message wording and line/column metadata aligned with official spec
- [x] Deserialization adapter (`Deserializer`, `deserialize_str`, `deserialize_value`, `deserialize_list`)
- [x] CLI validator (`cmd/main`) — validate `.nt` files and generate roundtrip output -->

## License

This project is dually licensed under the MIT License and the Apache License, Version 2.0. See `LICENSE`, `LICENSE-MIT`, and `LICENSE-APACHE` for details.
