///|
/// Parse a NestedText document string.
///
/// # Parameters
/// * `input` — The NestedText source text.
/// * `top` — Constrains the expected top-level shape. Pass `Top::Any` when the
///   structure is not known ahead of time.
///
/// # Returns
/// * `Ok(None)` — The document is empty and `top` is `Top::Any`.
/// * `Ok(Some(v))` — Successful parse. The returned `Value` matches
///   the constraint given by `top`.
/// * `Err(e)` — A `NestedTextError` describing the parse failure.
pub fn loads(input : String, top : Top) -> Result[Value?, NestedTextError] {
  if input.contains("\u{FFFD}") {
    let parts = input.split("\n")
    for lineno, part in parts {
      let line : String = part.to_owned()
      let found = line.find("\u{FFFD}")
      match found {
        Some(p) => {
          let prefix = line.unsafe_substring(start=0, end=p)
          let colno = prefix.char_length() + 1
          return Err(
            NestedTextError::at(
              UnrecognizedLine,
              "input contains invalid UTF-8",
              lineno + 1,
              colno,
              line,
            ),
          )
        }
        None => continue
      }
    }
  }
  let lexer_result = Lexer::from_string(input)
  match lexer_result {
    Err(err) => Err(err)
    Ok(lexer) => {
      let parser = Parser::new(lexer)
      let parsed = parser.read_value(0)
      match parsed {
        Err(err) => Err(err)
        Ok(value) =>
          match value {
            Some(_) =>
              match parser.lexer.peek() {
                Some(line) =>
                  if line.depth > 0 &&
                    parser.all_indent_levels.length() > 1 &&
                    !parser.all_indent_levels.contains(line.depth) {
                    Err(
                      NestedTextError::at(
                        InvalidIndentLevel,
                        "invalid indentation, partial dedent.",
                        line.lineno,
                        1,
                        line.text,
                      ),
                    )
                  } else {
                    Err(
                      NestedTextError::at(
                        UnexpectedLineType,
                        "extra content.",
                        line.lineno,
                        1,
                        line.text,
                      ),
                    )
                  }
                None => finish_top(value, top)
              }
            None => finish_top(value, top)
          }
      }
    }
  }
}

///|
fn finish_top(value : Value?, top : Top) -> Result[Value?, NestedTextError] {
  match (value, top) {
    (None, Top::Any) => Ok(None)
    (None, Top::Dict) => Ok(Some(Value::Dict([])))
    (None, Top::List) => Ok(Some(Value::List([])))
    (None, Top::String) => Ok(Some(Value::String("")))
    (Some(v), Top::Any) => Ok(Some(v))
    (Some(Value::Dict(_) as v), Top::Dict) => Ok(Some(v))
    (Some(Value::List(_) as v), Top::List) => Ok(Some(v))
    (Some(Value::String(_) as v), Top::String) => Ok(Some(v))
    (Some(_), Top::Dict) =>
      Err(
        NestedTextError::new(
          UnexpectedLineType,
          "expected dictionary top-level.",
        ),
      )
    (Some(_), Top::List) =>
      Err(NestedTextError::new(UnexpectedLineType, "expected list top-level."))
    (Some(_), Top::String) =>
      Err(
        NestedTextError::new(UnexpectedLineType, "expected string top-level."),
      )
  }
}
