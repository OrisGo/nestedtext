///|
pub(all) enum ErrorKind {
  InvalidIndentation
  TabInIndentation
  UnrecognizedLine
  UnexpectedLineType
  DuplicateKey
  InvalidIndentLevel
  UnterminatedInlineList
  UnterminatedInlineDict
  InvalidInlineCharacter
  TrailingContent
} derive(Debug, Eq)

///|
pub(all) struct NestedTextError {
  kind : ErrorKind
  message : String
  lineno : Int?
  colno : Int?
  line : String?
} derive(Debug, Eq)

///|
pub fn NestedTextError::new(
  kind : ErrorKind,
  message : String,
) -> NestedTextError {
  { kind, message, lineno: None, colno: None, line: None }
}

///|
pub fn NestedTextError::at(
  kind : ErrorKind,
  message : String,
  lineno : Int,
  colno : Int,
  line : String,
) -> NestedTextError {
  { kind, message, lineno: Some(lineno), colno: Some(colno), line: Some(line) }
}

///|
pub fn NestedTextError::with_lineno(
  self : NestedTextError,
  lineno : Int,
) -> NestedTextError {
  {
    kind: self.kind,
    message: self.message,
    lineno: Some(lineno),
    colno: self.colno,
    line: self.line,
  }
}

///|
pub fn NestedTextError::with_colno(
  self : NestedTextError,
  colno : Int,
) -> NestedTextError {
  {
    kind: self.kind,
    message: self.message,
    lineno: self.lineno,
    colno: Some(colno),
    line: self.line,
  }
}

///|
pub fn NestedTextError::with_line(
  self : NestedTextError,
  line : String,
) -> NestedTextError {
  {
    kind: self.kind,
    message: self.message,
    lineno: self.lineno,
    colno: self.colno,
    line: Some(line),
  }
}

///|
pub fn NestedTextError::to_string(self : NestedTextError) -> String {
  match self.lineno {
    Some(lineno) => "line \{lineno}: \{self.message}"
    None => self.message
  }
}
