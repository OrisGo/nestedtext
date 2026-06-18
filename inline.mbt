///|
priv struct InlineParser {
  input : String
  mut pos : Int
  lineno : Int
  colno_offset : Int
  line_text : String
}

///|
fn InlineParser::parse(
  input : String,
  lineno : Int,
  colno_offset : Int,
  line_text : String,
) -> Result[Value, NestedTextError] {
  let parser = { input, pos: 0, lineno, colno_offset, line_text }
  match parser.parse_value() {
    Err(err) => Err(err)
    Ok(value) => {
      parser.skip_any_whitespace()
      if parser.pos < parser.input.length() {
        let trailing = parser.input.unsafe_substring(
          start=parser.pos,
          end=parser.input.length(),
        )
        let trimmed = trailing.trim().to_owned()
        let msg = if trimmed.char_length() == 1 {
          "extra character after closing delimiter: \u{2018}\{trimmed}\u{2019}."
        } else {
          "extra characters after closing delimiter: \u{2018}\{trimmed}\u{2019}."
        }
        Err(parser.error(TrailingContent, msg))
      } else {
        Ok(value)
      }
    }
  }
}

///|
fn InlineParser::parse_value(
  self : InlineParser,
) -> Result[Value, NestedTextError] {
  match self.peek() {
    Some('[') => self.parse_list()
    Some('{') => self.parse_dict()
    _ =>
      Err(
        self.error(
          InvalidInlineCharacter,
          "expected \u{2018}[\u{2019} or \u{2018}{\u{2019}.",
        ),
      )
  }
}

///|
fn InlineParser::parse_list(
  self : InlineParser,
) -> Result[Value, NestedTextError] {
  self.advance_ignore()
  if self.peek() == Some(']') {
    self.advance_ignore()
    return Ok(Value::List([]))
  }
  let items : Array[Value] = []
  for ;; {
    self.skip_whitespace()
    let item_result = match self.peek() {
      Some('[') => self.parse_list()
      Some('{') => self.parse_dict()
      Some('}') => Err(self.error(InvalidInlineCharacter, "expected value."))
      _ =>
        Ok(Value::String(self.parse_inline_string(['[', ']', '{', '}', ','])))
    }
    let item = match item_result {
      Err(err) => return Err(err)
      Ok(v) => v
    }
    items.push(item)
    self.skip_whitespace()
    match self.peek() {
      Some(',') => self.advance_ignore()
      Some(']') => {
        self.advance_ignore()
        return Ok(Value::List(items))
      }
      Some(c) =>
        return Err(
          self.error(
            InvalidInlineCharacter,
            "expected \u{2018},\u{2019} or \u{2018}]\u{2019}, found \u{2018}\{c}\u{2019}.",
          ),
        )
      None =>
        return Err(
          self.error(
            UnterminatedInlineList,
            "line ended without closing delimiter.",
          ),
        )
    }
  }
}

///|
fn InlineParser::parse_dict(
  self : InlineParser,
) -> Result[Value, NestedTextError] {
  self.advance_ignore()
  if self.peek() == Some('}') {
    self.advance_ignore()
    return Ok(Value::Dict([]))
  }
  let pairs : Array[(String, Value)] = []
  let seen_keys : Array[String] = []
  for ;; {
    self.skip_whitespace()
    let key = self.parse_inline_string(['[', ']', '{', '}', ',', ':'])
    match self.peek() {
      Some(':') => self.advance_ignore()
      Some(c) =>
        return Err(
          self.error(
            InvalidInlineCharacter,
            "expected \u{2018}:\u{2019}, found \u{2018}\{c}\u{2019}.",
          ),
        )
      None =>
        return Err(
          self.error(
            UnterminatedInlineDict,
            "line ended without closing delimiter.",
          ),
        )
    }
    self.skip_whitespace()
    let value_result = match self.peek() {
      Some('[') => self.parse_list()
      Some('{') => self.parse_dict()
      Some('}') | Some(',') => Ok(Value::String(""))
      _ =>
        Ok(Value::String(self.parse_inline_string(['[', ']', '{', '}', ','])))
    }
    let value = match value_result {
      Err(err) => return Err(err)
      Ok(v) => v
    }
    if seen_keys.contains(key) {
      return Err(self.error(DuplicateKey, "duplicate key: \{key}."))
    }
    seen_keys.push(key)
    pairs.push((key, value))
    self.skip_whitespace()
    match self.peek() {
      Some(',') => {
        self.advance_ignore()
        if self.peek() == Some('}') {
          return Err(self.error(InvalidInlineCharacter, "expected value."))
        }
        self.skip_whitespace()
      }
      Some('}') => {
        self.advance_ignore()
        return Ok(Value::Dict(pairs))
      }
      Some(c) =>
        return Err(
          self.error(
            InvalidInlineCharacter,
            "expected \u{2018},\u{2019} or \u{2018}}\u{2019}, found \u{2018}\{c}\u{2019}.",
          ),
        )
      None =>
        return Err(
          self.error(
            UnterminatedInlineDict,
            "line ended without closing delimiter.",
          ),
        )
    }
  }
}

///|
fn InlineParser::parse_inline_string(
  self : InlineParser,
  forbidden : Array[Char],
) -> String {
  let start = self.pos
  for ;; {
    match self.peek() {
      Some(c) =>
        if forbidden.contains(c) {
          break
        } else {
          self.advance_ignore()
        }
      None => break
    }
  }
  self.input.unsafe_substring(start~, end=self.pos).trim().to_owned()
}

///|
fn InlineParser::peek(self : InlineParser) -> Char? {
  self.input.get_char(self.pos)
}

///|
fn InlineParser::advance_ignore(self : InlineParser) -> Unit {
  match self.peek() {
    Some(c) => self.pos += c.utf16_len()
    None => ()
  }
}

///|
fn InlineParser::skip_whitespace(self : InlineParser) -> Unit {
  for ;; {
    match self.peek() {
      Some(' ') | Some('\t') => self.advance_ignore()
      _ => break
    }
  }
}

///|
fn InlineParser::skip_any_whitespace(self : InlineParser) -> Unit {
  for ;; {
    match self.peek() {
      Some(c) =>
        if c.is_ascii_whitespace() {
          self.advance_ignore()
        } else {
          break
        }
      None => break
    }
  }
}

///|
fn InlineParser::error(
  self : InlineParser,
  kind : ErrorKind,
  message : String,
) -> NestedTextError {
  NestedTextError::at(
    kind,
    message,
    self.lineno,
    self.colno_offset + self.pos,
    self.line_text,
  )
}
