///|
priv enum LineKind {
  ListItem
  DictItem
  StringItem
  KeyItem
  InlineDict
  InlineList
  Unrecognized
} derive(Eq)

///|
priv struct Line {
  kind : LineKind
  lineno : Int
  depth : Int
  key : String?
  value : String?
  text : String
}

///|
priv struct Lexer {
  lines : Array[Line]
  mut pos : Int
}

///|
fn Lexer::from_string(input : String) -> Result[Lexer, NestedTextError] {
  let stripped = match input.strip_prefix("\u{FEFF}") {
    Some(rest) => rest.to_owned()
    None => input
  }
  let normalized = stripped
    .replace_all(old="\r\n", new="\n")
    .replace_all(old="\r", new="\n")
  let lines : Array[Line] = []
  for lineno, raw_view in normalized.split("\n") {
    let raw = raw_view.to_owned()
    let depth = count_leading_spaces(raw)
    match check_indentation(raw, lineno) {
      Some(err) => return Err(err)
      None => ()
    }
    let rest = raw.unsafe_substring(start=depth, end=raw.length())
    if rest.is_empty() || rest.has_prefix("#") {
      continue
    }
    lines.push(classify_line(rest, depth, lineno, raw))
  }
  Ok({ lines, pos: 0 })
}

///|
fn Lexer::peek(self : Lexer) -> Line? {
  self.lines.get(self.pos)
}

///|
fn Lexer::next_line(self : Lexer) -> Line? {
  match self.lines.get(self.pos) {
    Some(line) => {
      self.pos += 1
      Some(line)
    }
    None => None
  }
}

///|
fn Lexer::next_is(self : Lexer, depth : Int, kind : LineKind) -> Bool {
  match self.peek() {
    Some(line) => line.depth == depth && line.kind == kind
    None => false
  }
}

///|
fn count_leading_spaces(line : String) -> Int {
  for count = 0, i = 0; i < line.length(); {
    if line[i] == ' ' {
      continue count + 1, i + 1
    } else {
      break count
    }
  } nobreak {
    count
  }
}

///|
fn check_indentation(raw : String, lineno : Int) -> NestedTextError? {
  for colno, ch in raw.iter2() {
    if ch == ' ' {
      continue
    }
    if ch == '\t' {
      return Some(
        NestedTextError::at(
          TabInIndentation,
          "invalid character in indentation: '\\t'.",
          lineno,
          colno,
          raw,
        ),
      )
    }
    if ch.is_whitespace() {
      let desc = if ch == '\u{00A0}' {
        "'\\xa0' (NO-BREAK SPACE)."
      } else {
        "'\\u{\{ch.to_int()}}'."
      }
      return Some(
        NestedTextError::at(
          InvalidIndentation,
          "invalid character in indentation: \{desc}",
          lineno,
          colno,
          raw,
        ),
      )
    }
    break None
  } nobreak {
    None
  }
}

///|
fn classify_line(
  rest : String,
  depth : Int,
  lineno : Int,
  raw : String,
) -> Line {
  if rest.has_prefix("- ") || rest == "-" {
    let value = if rest == "-" {
      ""
    } else {
      rest.unsafe_substring(start=2, end=rest.length())
    }
    return {
      kind: ListItem,
      lineno,
      depth,
      key: None,
      value: Some(value),
      text: raw,
    }
  }
  if rest.has_prefix("> ") || rest == ">" {
    let value = if rest == ">" {
      ""
    } else {
      rest.unsafe_substring(start=2, end=rest.length())
    }
    return {
      kind: StringItem,
      lineno,
      depth,
      key: None,
      value: Some(value),
      text: raw,
    }
  }
  if rest.has_prefix(": ") || rest == ":" {
    let value = if rest == ":" {
      ""
    } else {
      rest.unsafe_substring(start=2, end=rest.length())
    }
    return {
      kind: KeyItem,
      lineno,
      depth,
      key: None,
      value: Some(value),
      text: raw,
    }
  }
  if rest.has_prefix("[") {
    return {
      kind: InlineList,
      lineno,
      depth,
      key: None,
      value: Some(rest),
      text: raw,
    }
  }
  if rest.has_prefix("{") {
    return {
      kind: InlineDict,
      lineno,
      depth,
      key: None,
      value: Some(rest),
      text: raw,
    }
  }
  match try_parse_dict_item(rest) {
    Some((key, value)) =>
      {
        kind: DictItem,
        lineno,
        depth,
        key: Some(key),
        value: Some(value),
        text: raw,
      }
    None =>
      { kind: Unrecognized, lineno, depth, key: None, value: None, text: raw }
  }
}

///|
fn try_parse_dict_item(rest : String) -> (String, String)? {
  match rest.find(": ") {
    Some(colon_pos) => {
      let key = rest
        .unsafe_substring(start=0, end=colon_pos)
        .trim_end()
        .to_owned()
      let value = rest.unsafe_substring(start=colon_pos + 2, end=rest.length())
      if key.is_empty() {
        None
      } else {
        Some((key, value))
      }
    }
    None =>
      if rest.has_suffix(":") {
        let key = rest
          .unsafe_substring(start=0, end=rest.length() - 1)
          .trim_end()
          .to_owned()
        if key.is_empty() {
          None
        } else {
          Some((key, ""))
        }
      } else {
        None
      }
  }
}
