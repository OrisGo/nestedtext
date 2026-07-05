///|
test "expect_string extracts string value" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("hello"))
  match d.expect_string() {
    Ok(s) => @debug.assert_eq(s, "hello")
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_string errors on list" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::List([@nestedtext.Value::String("")]),
  )
  match d.expect_string() {
    Err(e) => @debug.assert_eq(e.message, "expected string, got list")
    Ok(_) => fail("expected error")
  }
}

///|
test "expect_string errors on dict" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::Dict([("k", @nestedtext.Value::String("v"))]),
  )
  match d.expect_string() {
    Err(e) => @debug.assert_eq(e.message, "expected string, got dictionary")
    Ok(_) => fail("expected error")
  }
}

///|
test "expect_int parses natural number" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("42"))
  match d.expect_int() {
    Ok(n) => @debug.assert_eq(n, 42)
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_int parses negative number" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("-7"))
  match d.expect_int() {
    Ok(n) => @debug.assert_eq(n, -7)
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_int parses whitespace-padded number" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("  100  "))
  match d.expect_int() {
    Ok(n) => @debug.assert_eq(n, 100)
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_int errors on non-numeric string" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("nope"))
  match d.expect_int() {
    Err(e) => @debug.assert_eq(e.message, "cannot parse 'nope' as Int")
    Ok(_) => fail("expected error")
  }
}

///|
test "expect_double parses float" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("3.14"))
  match d.expect_double() {
    Ok(n) => @debug.assert_eq(n, 3.14)
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_double errors on non-numeric string" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("abc"))
  match d.expect_double() {
    Err(e) => @debug.assert_eq(e.message, "cannot parse 'abc' as Double")
    Ok(_) => fail("expected error")
  }
}

///|
test "expect_bool recognises true / false" {
  let pairs = [
    ("true", true),
    ("True", true),
    ("TRUE", true),
    ("yes", true),
    ("Yes", true),
    ("YES", true),
    ("false", false),
    ("False", false),
    ("FALSE", false),
    ("no", false),
    ("No", false),
    ("NO", false),
  ]
  for pair in pairs {
    let (text, expected) = pair
    let d = @nestedtext.Deserializer::new(@nestedtext.Value::String(text))
    match d.expect_bool() {
      Ok(b) => @debug.assert_eq(b, expected)
      Err(e) => fail("unexpected error for '\{text}': \{e.message}")
    }
  }
}

///|
test "expect_bool errors on arbitrary string" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("maybe"))
  match d.expect_bool() {
    Err(e) => @debug.assert_eq(e.message, "cannot parse 'maybe' as Bool")
    Ok(_) => fail("expected error")
  }
}

///|
test "get_field returns value for existing key" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::Dict([
      ("name", @nestedtext.Value::String("Alice")),
      ("age", @nestedtext.Value::String("30")),
    ]),
  )
  match d.get_field("name") {
    Ok(field_d) =>
      match field_d.expect_string() {
        Ok(s) => @debug.assert_eq(s, "Alice")
        Err(e) => fail("unexpected error: \{e.message}")
      }
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "get_field errors for missing key" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::Dict([("a", @nestedtext.Value::String("1"))]),
  )
  match d.get_field("b") {
    Err(e) => @debug.assert_eq(e.message, "missing field: b")
    Ok(_) => fail("expected error")
  }
}

///|
test "get_field errors on non-dict" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("hi"))
  match d.get_field("x") {
    Err(e) => @debug.assert_eq(e.message, "expected dictionary, got string")
    Ok(_) => fail("expected error")
  }
}

///|
test "expect_list returns items" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::List([
      @nestedtext.Value::String("a"),
      @nestedtext.Value::String("b"),
    ]),
  )
  match d.expect_list() {
    Ok(items) => {
      @debug.assert_eq(items.length(), 2)
      @debug.assert_eq(items[0], @nestedtext.Value::String("a"))
      @debug.assert_eq(items[1], @nestedtext.Value::String("b"))
    }
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_list errors on string" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("a"))
  match d.expect_list() {
    Err(e) => @debug.assert_eq(e.message, "expected list, got string")
    Ok(_) => fail("expected error")
  }
}

///|
test "deserialize_list deserializes typed elements" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::List([
      @nestedtext.Value::String("1"),
      @nestedtext.Value::String("2"),
      @nestedtext.Value::String("3"),
    ]),
  )
  match @nestedtext.deserialize_list(d, fn(d2) { d2.expect_int() }) {
    Ok(ints) => @debug.assert_eq(ints, [1, 2, 3])
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_optional returns None for empty string" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String(""))
  match d.expect_optional(fn(d2) { d2.expect_int() }) {
    Ok(None) => ()
    Ok(Some(n)) => fail("expected None, got Some(\{n})")
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_optional returns Some for non-empty" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("42"))
  match d.expect_optional(fn(d2) { d2.expect_int() }) {
    Ok(Some(42)) => ()
    _ => fail("expected Some(42)")
  }
}

///|
test "has_field returns true for existing key" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::Dict([("name", @nestedtext.Value::String("Alice"))]),
  )
  assert_true(d.has_field("name"))
  assert_false(d.has_field("age"))
}

///|
test "has_field returns false for non-dict" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("hi"))
  assert_false(d.has_field("key"))
}

///|
test "field_names returns keys from dict" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::Dict([
      ("name", @nestedtext.Value::String("Alice")),
      ("age", @nestedtext.Value::String("30")),
    ]),
  )
  let names = d.field_names()
  @debug.assert_eq(names, ["name", "age"])
}

///|
test "field_names returns empty for non-dict" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("hi"))
  @debug.assert_eq(d.field_names(), [])
}

///|
test "deserialize_str parses simple dict to typed tuple" {
  fn parse_person(
    d : @nestedtext.Deserializer,
  ) -> Result[(String, Int), @nestedtext.DeserializeError] {
    match d.get_field("name") {
      Ok(name_d) =>
        match name_d.expect_string() {
          Ok(name) =>
            match d.get_field("age") {
              Ok(age_d) =>
                match age_d.expect_int() {
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
  match @nestedtext.deserialize_str(input, @nestedtext.Top::Any, parse_person) {
    Ok((name, age)) => {
      @debug.assert_eq(name, "Alice")
      @debug.assert_eq(age, 30)
    }
    Err(e) => fail("unexpected error: \{e.to_string()}")
  }
}

///|
test "deserialize_str deserializes list of numbers" {
  fn parse_numbers(
    d : @nestedtext.Deserializer,
  ) -> Result[Array[Int], @nestedtext.DeserializeError] {
    @nestedtext.deserialize_list(d, fn(d2) { d2.expect_int() })
  }
  let input = "- 1\n- 2\n- 3"
  match
    @nestedtext.deserialize_str(input, @nestedtext.Top::Any, parse_numbers) {
    Ok(nums) => @debug.assert_eq(nums, [1, 2, 3])
    Err(e) => fail("unexpected error: \{e.to_string()}")
  }
}

///|
test "deserialize_str handles empty document" {
  fn parse_opt(
    d : @nestedtext.Deserializer,
  ) -> Result[Int?, @nestedtext.DeserializeError] {
    d.expect_optional(fn(d2) { d2.expect_int() })
  }
  match @nestedtext.deserialize_str("", @nestedtext.Top::Any, parse_opt) {
    Ok(None) => ()
    _ => fail("expected None")
  }
}

///|
test "deserialize_str reports deserialization errors" {
  fn parse_int(
    d : @nestedtext.Deserializer,
  ) -> Result[Int, @nestedtext.DeserializeError] {
    d.expect_int()
  }
  match
    @nestedtext.deserialize_str("key: value", @nestedtext.Top::Any, parse_int) {
    Err(e) => @debug.assert_eq(e.message, "expected string, got dictionary")
    Ok(_) => fail("expected error")
  }
}

///|
test "deserialize_str reports parse error on invalid string" {
  fn parse_int(
    d : @nestedtext.Deserializer,
  ) -> Result[Int, @nestedtext.DeserializeError] {
    d.expect_int()
  }
  match @nestedtext.deserialize_str("> nope", @nestedtext.Top::Any, parse_int) {
    Err(e) => @debug.assert_eq(e.message, "cannot parse 'nope' as Int")
    Ok(_) => fail("expected error")
  }
}

///|
test "deserialize_value deserializes typed value" {
  let value = @nestedtext.Value::Dict([
    ("x", @nestedtext.Value::String("10")),
    ("y", @nestedtext.Value::String("20")),
  ])
  fn point(
    d : @nestedtext.Deserializer,
  ) -> Result[(Int, Int), @nestedtext.DeserializeError] {
    match d.get_field("x") {
      Ok(xd) =>
        match xd.expect_int() {
          Ok(x) =>
            match d.get_field("y") {
              Ok(yd) =>
                match yd.expect_int() {
                  Ok(y) => Ok((x, y))
                  Err(e) => Err(e)
                }
              Err(e) => Err(e)
            }
          Err(e) => Err(e)
        }
      Err(e) => Err(e)
    }
  }
  match @nestedtext.deserialize_value(value, point) {
    Ok((10, 20)) => ()
    _ => fail("expected (10, 20)")
  }
}

///|
test "expect_bool trims whitespace" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("  true  "))
  match d.expect_bool() {
    Ok(b) => assert_true(b)
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_int64 parses large number" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::String("9223372036854775807"),
  )
  match d.expect_int64() {
    Ok(n) => @debug.assert_eq(n, 9223372036854775807L)
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "expect_int errors on non-string type" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::List([@nestedtext.Value::String("1")]),
  )
  match d.expect_int() {
    Err(e) => @debug.assert_eq(e.message, "expected string, got list")
    Ok(_) => fail("expected error")
  }
}

///|
test "expect_double errors on non-string type" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::Dict([]))
  match d.expect_double() {
    Err(e) => @debug.assert_eq(e.message, "expected string, got dictionary")
    Ok(_) => fail("expected error")
  }
}

///|
test "as_value returns underlying Value" {
  let v = @nestedtext.Value::String("hello")
  let d = @nestedtext.Deserializer::new(v)
  @debug.assert_eq(d.as_value(), v)
}

///|
test "deserialize_list on empty list" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::List([]))
  match @nestedtext.deserialize_list(d, fn(d2) { d2.expect_int() }) {
    Ok(nums) => @debug.assert_eq(nums, [])
    Err(e) => fail("unexpected error: \{e.message}")
  }
}

///|
test "deserialize_list on non-list errors" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String("not a list"))
  match @nestedtext.deserialize_list(d, fn(d2) { d2.expect_int() }) {
    Err(e) => @debug.assert_eq(e.message, "expected list, got string")
    Ok(_) => fail("expected error")
  }
}

///|
test "DeserializeError type_mismatch constructor" {
  let e = @nestedtext.DeserializeError::type_mismatch("int", "string")
  @debug.assert_eq(e.message, "expected int, got string")
}

///|
test "DeserializeError parse_error constructor" {
  let e = @nestedtext.DeserializeError::parse_error("hello", "Int")
  @debug.assert_eq(e.message, "cannot parse 'hello' as Int")
}

///|
test "DeserializeError missing_field constructor" {
  let e = @nestedtext.DeserializeError::missing_field("age")
  @debug.assert_eq(e.message, "missing field: age")
}

///|
test "DeserializeError new constructor" {
  let e = @nestedtext.DeserializeError::new("custom error")
  @debug.assert_eq(e.message, "custom error")
}
