///|
test "derived methods remain callable through public types" {
  let value = @nestedtext.Value::String("example")
  assert_true(@nestedtext.Value::equal(value, value))
  assert_true(
    @nestedtext.Value::not_equal(value, @nestedtext.Value::String("other")),
  )
  ignore(@nestedtext.Value::to_repr(value))
  let top = @nestedtext.Top::Dict
  assert_true(@nestedtext.Top::equal(top, top))
  ignore(@nestedtext.Top::to_repr(top))
  let kind = @nestedtext.ErrorKind::DuplicateKey
  assert_true(@nestedtext.ErrorKind::equal(kind, kind))
  ignore(@nestedtext.ErrorKind::to_repr(kind))
  let error = @nestedtext.NestedTextError::new(kind, "duplicate key")
  assert_true(@nestedtext.NestedTextError::equal(error, error))
  ignore(@nestedtext.NestedTextError::to_repr(error))
  let decode_error = @nestedtext.DeserializeError::new("invalid value")
  assert_true(@nestedtext.DeserializeError::equal(decode_error, decode_error))
  ignore(@nestedtext.DeserializeError::to_repr(decode_error))
  let deserializer = @nestedtext.Deserializer::new(value)
  assert_true(@nestedtext.Deserializer::equal(deserializer, deserializer))
  ignore(@nestedtext.Deserializer::to_repr(deserializer))
  ignore(@nestedtext.DumpOptions::to_repr(@nestedtext.DumpOptions::default()))
}

///|
test "loads simple dictionary" {
  let input = "name: Alice\nage: 30"
  let result = @nestedtext.loads(input, @nestedtext.Top::Any)
  match result {
    Ok(Some(value)) =>
      assert_true(
        value ==
        @nestedtext.Value::Dict([
          ("name", @nestedtext.Value::String("Alice")),
          ("age", @nestedtext.Value::String("30")),
        ]),
      )
    other => fail("unexpected result: \{Repr(other)}")
  }
}

///|
test "loads nested list under dictionary" {
  let input = "fruits:\n  - apple\n  - banana"
  match @nestedtext.loads(input, @nestedtext.Top::Dict) {
    Ok(Some(value)) =>
      assert_true(
        value ==
        @nestedtext.Value::Dict([
          (
            "fruits",
            @nestedtext.Value::List([
              @nestedtext.Value::String("apple"),
              @nestedtext.Value::String("banana"),
            ]),
          ),
        ]),
      )
    other => fail("unexpected result: \{Repr(other)}")
  }
}

///|
test "reports indentation location" {
  match @nestedtext.loads("  key: value", @nestedtext.Top::Any) {
    Err(err) => {
      @debug.assert_eq(err.message, "top-level content must start in column 1.")
      assert_true(err.lineno == Some(1))
      assert_true(err.colno == Some(1))
    }
    Ok(value) => fail("expected indentation error, got \{Repr(value)}")
  }
}
