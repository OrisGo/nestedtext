///|
test "dumps simple string" {
  let value = @nestedtext.Value::String("hello")
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "> hello\n")
}

///|
test "dumps multiline string" {
  let value = @nestedtext.Value::String("line one\nline two")
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "> line one\n> line two\n")
}

///|
test "dumps empty string" {
  let value = @nestedtext.Value::String("")
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, ">\n")
}

///|
test "dumps simple list" {
  let value = @nestedtext.Value::List([
    @nestedtext.Value::String("a"),
    @nestedtext.Value::String("b"),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "- a\n- b\n")
}

///|
test "dumps empty list" {
  let value = @nestedtext.Value::List([])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "[]\n")
}

///|
test "dumps simple dict" {
  let value = @nestedtext.Value::Dict([
    ("name", @nestedtext.Value::String("Alice")),
    ("age", @nestedtext.Value::String("30")),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "name: Alice\nage: 30\n")
}

///|
test "dumps empty dict" {
  let value = @nestedtext.Value::Dict([])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "{}\n")
}

///|
test "dumps nested dict with list" {
  let value = @nestedtext.Value::Dict([
    (
      "items",
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("b"),
      ]),
    ),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "items:\n    - a\n    - b\n")
}

///|
test "dumps empty value in dict" {
  let value = @nestedtext.Value::Dict([("key", @nestedtext.Value::String(""))])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "key:\n")
}

///|
test "dumps empty list item" {
  let value = @nestedtext.Value::List([
    @nestedtext.Value::String(""),
    @nestedtext.Value::String("hello"),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "-\n- hello\n")
}

///|
test "dumps sorted keys" {
  let value = @nestedtext.Value::Dict([
    ("z", @nestedtext.Value::String("last")),
    ("a", @nestedtext.Value::String("first")),
  ])
  let opts = @nestedtext.DumpOptions::{ indent: 4, sort_keys: true }
  let result = @nestedtext.dumps(value, opts)
  assert_eq(result, "a: first\nz: last\n")
}

///|
test "dumps multiline key" {
  let value = @nestedtext.Value::Dict([
    ("multiline\nkey", @nestedtext.Value::String("value")),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, ": multiline\n: key\n    > value\n")
}

///|
test "dumps empty key" {
  let value = @nestedtext.Value::Dict([("", @nestedtext.Value::String("value"))])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, ":\n    > value\n")
}

///|
test "dumps key with colon suffix" {
  let value = @nestedtext.Value::Dict([
    ("key:", @nestedtext.Value::String("value")),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, ": key:\n    > value\n")
}

///|
test "roundtrip simple dict" {
  let input = "name: Alice\nage: 30"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(value)) => {
      let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
      assert_eq(output, "name: Alice\nage: 30\n")
      match @nestedtext.loads(output, @nestedtext.Top::Any) {
        Ok(Some(rv)) => assert_true(value == rv)
        _ => fail("roundtrip parse failed")
      }
    }
    _ => fail("initial parse failed")
  }
}

///|
test "roundtrip nested" {
  let input = "fruits:\n  - apple\n  - banana\nveggies:\n  - carrot"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(value)) => {
      let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
      assert_eq(
        output, "fruits:\n    - apple\n    - banana\nveggies:\n    - carrot\n",
      )
      match @nestedtext.loads(output, @nestedtext.Top::Any) {
        Ok(Some(rv)) => assert_true(value == rv)
        _ => fail("roundtrip parse failed")
      }
    }
    _ => fail("initial parse failed")
  }
}

///|
test "dumps string with leading whitespace" {
  let value = @nestedtext.Value::String("  indented")
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, ">   indented\n")
}

///|
test "dumps list with nested dicts" {
  let value = @nestedtext.Value::List([
    @nestedtext.Value::Dict([("name", @nestedtext.Value::String("John"))]),
    @nestedtext.Value::Dict([("name", @nestedtext.Value::String("Jane"))]),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "-\n    name: John\n-\n    name: Jane\n")
}

///|
test "dumps list with complex value indentation" {
  let value = @nestedtext.Value::List([
    @nestedtext.Value::String("simple"),
    @nestedtext.Value::List([@nestedtext.Value::String("nested")]),
  ])
  let result = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  assert_eq(result, "- simple\n-\n    - nested\n")
}
