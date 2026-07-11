///|
/// Categories of errors that can occur during NestedText parsing.
///
/// # Variants
/// * `InvalidIndentation` — Indentation uses an unknown mixture of spaces or
///   does not match any previously established indentation level.
/// * `TabInIndentation` — A tab character was used for indentation. NestedText
///   requires spaces.
/// * `UnrecognizedLine` — The line contains characters that cannot be recognised
///   (e.g. invalid UTF-8).
/// * `UnexpectedLineType` — The line type (dict item, list item, string) does
///   not match the expected shape of the enclosing value.
/// * `DuplicateKey` — A dictionary key appears more than once within the same
///   dictionary.
/// * `InvalidIndentLevel` — The indentation level does not correspond to any
///   level established by the containing structure (partial dedent).
/// * `UnterminatedInlineList` — An inline list `[...]` is missing its closing
///   bracket.
/// * `UnterminatedInlineDict` — An inline dictionary `{...}` is missing its
///   closing brace.
/// * `InvalidInlineCharacter` — An unexpected character was found inside an
///   inline list or dictionary.
/// * `TrailingContent` — Extra characters were found after a complete inline
///   value.
/// * `DeserializationError` — A typed-deserialization step failed. The
///   accompanying message provides the detail.
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
  DeserializationError
} derive(Debug, Eq)

///|
/// A parse or deserialization error with optional source-location context.
///
/// # Fields
/// * `kind` — The category of error.
/// * `message` — A human-readable description of the problem.
/// * `lineno` — The 1-based line number where the error occurred (if known).
/// * `colno` — The 1-based column number where the error occurred (if known).
/// * `line` — The text of the offending line (if available).
pub(all) struct NestedTextError {
  kind : ErrorKind
  message : String
  lineno : Int?
  colno : Int?
  line : String?
} derive(Debug, Eq)

///|
/// Create an error without location information.
pub fn NestedTextError::new(
  kind : ErrorKind,
  message : String,
) -> NestedTextError {
  { kind, message, lineno: None, colno: None, line: None }
}

///|
/// Create an error with full location information.
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
/// Set or replace the line number on an existing error.
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
/// Set or replace the column number on an existing error.
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
/// Set or replace the source line on an existing error.
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
/// Format the error as a human-readable string.
///
/// If a line number is available the output is `"line <n>: <message>"`;
/// otherwise it is just `<message>`.
pub fn NestedTextError::to_string(self : NestedTextError) -> String {
  match self.lineno {
    Some(lineno) => "line \{lineno}: \{self.message}"
    None => self.message
  }
}
