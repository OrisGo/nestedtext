///|
priv struct Parser {
  lexer : Lexer
  indent_stack : Array[Int]
  all_indent_levels : Array[Int]
}

///|
fn Parser::new(lexer : Lexer) -> Parser {
  { lexer, indent_stack: [], all_indent_levels: [0] }
}

///|
fn Parser::read_value(
  self : Parser,
  depth : Int,
) -> Result[Value?, NestedTextError] {
  match self.lexer.peek() {
    None => Ok(None)
    Some(line) =>
      if line.depth < depth {
        Ok(None)
      } else if line.depth > depth {
        if depth == 0 && self.indent_stack.is_empty() {
          Err(
            NestedTextError::at(
              InvalidIndentLevel,
              "top-level content must start in column 1.",
              line.lineno,
              0,
              line.text,
            ),
          )
        } else if !self.indent_stack.is_empty() &&
          !self.indent_stack.contains(line.depth) {
          Err(
            NestedTextError::at(
              InvalidIndentLevel,
              "invalid indentation, partial dedent.",
              line.lineno,
              0,
              line.text,
            ),
          )
        } else {
          Err(
            NestedTextError::at(
              InvalidIndentLevel,
              "invalid indentation.",
              line.lineno,
              line.depth,
              line.text,
            ),
          )
        }
      } else {
        match line.kind {
          DictItem | KeyItem => self.read_dict(depth).map(v => Some(v))
          ListItem => self.read_list(depth).map(v => Some(v))
          StringItem => self.read_string(depth).map(v => Some(v))
          InlineList | InlineDict => {
            let consumed = self.lexer.next_line().unwrap()
            match consumed.value {
              Some(input) =>
                InlineParser::parse(
                  input,
                  consumed.lineno,
                  consumed.depth,
                  consumed.text,
                ).map(v => Some(v))
              None =>
                Err(
                  NestedTextError::new(UnrecognizedLine, "unrecognized line."),
                )
            }
          }
          Unrecognized =>
            Err(
              NestedTextError::at(
                UnrecognizedLine,
                "unrecognized line.",
                line.lineno,
                line.depth,
                line.text,
              ),
            )
        }
      }
  }
}

///|
fn Parser::read_dict(
  self : Parser,
  depth : Int,
) -> Result[Value, NestedTextError] {
  let pairs : Array[(String, Value)] = []
  let seen_keys : Array[String] = []
  for ;; {
    match self.lexer.peek() {
      Some(line) =>
        if line.depth != depth {
          break
        } else {
          match line.kind {
            DictItem => {
              let consumed = self.lexer.next_line().unwrap()
              let key = consumed.key.unwrap()
              let raw_value = consumed.value.unwrap()
              if seen_keys.contains(key) {
                return Err(
                  NestedTextError::at(
                    DuplicateKey,
                    "duplicate key: \{key}.",
                    consumed.lineno,
                    0,
                    consumed.text,
                  ),
                )
              }
              seen_keys.push(key)
              let value = if !raw_value.is_empty() {
                match self.check_no_indented_content(depth) {
                  Err(err) => return Err(err)
                  Ok(_) => Value::String(raw_value)
                }
              } else {
                match self.read_indented_value(depth) {
                  Err(err) => return Err(err)
                  Ok(v) => v
                }
              }
              pairs.push((key, value))
            }
            KeyItem => {
              let first_key_lineno = line.lineno
              let first_key_text = line.text
              let key = self.read_key(depth)
              if seen_keys.contains(key) {
                return Err(
                  NestedTextError::new(DuplicateKey, "duplicate key: \{key}."),
                )
              }
              seen_keys.push(key)
              match self.lexer.peek() {
                Some(next_line) =>
                  if next_line.depth > depth {
                    let child_depth = next_line.depth
                    self.indent_stack.push(child_depth)
                    self.all_indent_levels.push(child_depth)
                    let value_result = self.read_value(child_depth)
                    ignore(self.indent_stack.pop())
                    match value_result {
                      Err(err) => return Err(err)
                      Ok(Some(v)) => pairs.push((key, v))
                      Ok(None) => pairs.push((key, Value::String("")))
                    }
                  } else {
                    return Err(
                      NestedTextError::at(
                        InvalidIndentLevel,
                        "multiline key requires a value.",
                        first_key_lineno,
                        depth,
                        first_key_text,
                      ),
                    )
                  }
                None =>
                  return Err(
                    NestedTextError::new(
                      InvalidIndentLevel,
                      "indented value must follow multiline key.",
                    )
                    .with_lineno(first_key_lineno)
                    .with_line(first_key_text),
                  )
              }
            }
            _ =>
              return Err(
                NestedTextError::at(
                  UnexpectedLineType,
                  "expected dictionary item.",
                  line.lineno,
                  line.depth,
                  line.text,
                ),
              )
          }
        }
      None => break
    }
  }
  Ok(Value::Dict(pairs))
}

///|
fn Parser::read_list(
  self : Parser,
  depth : Int,
) -> Result[Value, NestedTextError] {
  let items : Array[Value] = []
  for ;; {
    match self.lexer.peek() {
      Some(line) =>
        if line.depth != depth {
          break
        } else if line.kind == ListItem {
          let consumed = self.lexer.next_line().unwrap()
          let raw_value = consumed.value.unwrap()
          let value = if !raw_value.is_empty() {
            match self.check_no_indented_content(depth) {
              Err(err) => return Err(err)
              Ok(_) => Value::String(raw_value)
            }
          } else {
            match self.read_indented_value(depth) {
              Err(err) => return Err(err)
              Ok(v) => v
            }
          }
          items.push(value)
        } else {
          return Err(
            NestedTextError::at(
              UnexpectedLineType,
              "expected list item.",
              line.lineno,
              line.depth,
              line.text,
            ),
          )
        }
      None => break
    }
  }
  Ok(Value::List(items))
}

///|
fn Parser::read_string(
  self : Parser,
  depth : Int,
) -> Result[Value, NestedTextError] {
  let parts : Array[String] = []
  while self.lexer.next_is(depth, StringItem) {
    let line = self.lexer.next_line().unwrap()
    parts.push(line.value.unwrap())
  }
  match self.lexer.peek() {
    Some(next) =>
      if next.depth > depth && next.kind == StringItem {
        Err(
          NestedTextError::at(
            InvalidIndentLevel,
            "invalid indentation.",
            next.lineno,
            depth,
            next.text,
          ),
        )
      } else {
        Ok(Value::String(parts.join("\n")))
      }
    None => Ok(Value::String(parts.join("\n")))
  }
}

///|
fn Parser::read_key(self : Parser, depth : Int) -> String {
  let parts : Array[String] = []
  while self.lexer.next_is(depth, KeyItem) {
    let line = self.lexer.next_line().unwrap()
    parts.push(line.value.unwrap())
  }
  parts.join("\n")
}

///|
fn Parser::read_indented_value(
  self : Parser,
  parent_depth : Int,
) -> Result[Value, NestedTextError] {
  match self.lexer.peek() {
    Some(line) =>
      if line.depth > parent_depth {
        let child_depth = line.depth
        self.indent_stack.push(child_depth)
        self.all_indent_levels.push(child_depth)
        let result = self.read_value(child_depth)
        ignore(self.indent_stack.pop())
        match result {
          Err(err) => Err(err)
          Ok(Some(v)) => Ok(v)
          Ok(None) =>
            Err(NestedTextError::new(UnexpectedLineType, "expected value."))
        }
      } else {
        Ok(Value::String(""))
      }
    None => Ok(Value::String(""))
  }
}

///|
fn Parser::check_no_indented_content(
  self : Parser,
  parent_depth : Int,
) -> Result[Unit, NestedTextError] {
  match self.lexer.peek() {
    Some(next) =>
      if next.depth > parent_depth {
        Err(
          NestedTextError::at(
            InvalidIndentLevel,
            "invalid indentation.",
            next.lineno,
            parent_depth,
            next.text,
          ),
        )
      } else {
        Ok(())
      }
    None => Ok(())
  }
}
