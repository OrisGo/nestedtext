///|
test "lexer skips blank lines and comments" {
  match Lexer::from_string("# comment\n\n  # indented comment\nkey: value") {
    Ok(lexer) =>
      match lexer.peek() {
        Some(line) => {
          assert_true(line.kind == DictItem)
          assert_eq(line.depth, 0)
          assert_true(line.key == Some("key"))
          assert_true(line.value == Some("value"))
        }
        None => fail("expected one classified line")
      }
    Err(err) => fail("unexpected lexer error: \{err.to_string()}")
  }
}

///|
test "inline parser accepts nested values" {
  match
    InlineParser::parse("[a, [b, c], {d: e}]", 0, 0, "[a, [b, c], {d: e}]") {
    Ok(value) =>
      assert_true(
        value ==
        Value::List([
          Value::String("a"),
          Value::List([Value::String("b"), Value::String("c")]),
          Value::Dict([("d", Value::String("e"))]),
        ]),
      )
    Err(err) => fail("unexpected inline error: \{err.to_string()}")
  }
}
