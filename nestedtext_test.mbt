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
    other => fail("unexpected result: \{to_repr(other)}")
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
    other => fail("unexpected result: \{to_repr(other)}")
  }
}

///|
test "reports indentation location" {
  match @nestedtext.loads("  key: value", @nestedtext.Top::Any) {
    Err(err) => {
      assert_eq(err.message, "top-level content must start in column 1.")
      assert_true(err.lineno == Some(0))
      assert_true(err.colno == Some(0))
    }
    Ok(value) => fail("expected indentation error, got \{to_repr(value)}")
  }
}
