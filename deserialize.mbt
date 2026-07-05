///|
/// Error returned when deserialization of a `Value` into a typed target fails.
pub(all) struct DeserializeError {
  message : String
} derive(Debug, Eq)

///|
pub fn DeserializeError::new(message : String) -> DeserializeError {
  { message, }
}

///|
pub fn DeserializeError::type_mismatch(
  expected : String,
  actual : String,
) -> DeserializeError {
  { message: "expected \{expected}, got \{actual}" }
}

///|
pub fn DeserializeError::parse_error(
  value : String,
  target_type : String,
) -> DeserializeError {
  { message: "cannot parse '\{value}' as \{target_type}" }
}

///|
pub fn DeserializeError::missing_field(field_name : String) -> DeserializeError {
  { message: "missing field: \{field_name}" }
}

///|
/// A typed view over a parsed `Value` that extracts MoonBit values.
pub(all) struct Deserializer {
  value : Value
} derive(Debug, Eq)

///|
pub fn Deserializer::new(value : Value) -> Deserializer {
  { value, }
}

///|
/// Return the raw `Value` this deserializer wraps.
pub fn Deserializer::as_value(self : Deserializer) -> Value {
  self.value
}

///|
fn value_type_name(value : Value) -> String {
  match value {
    Value::String(_) => "string"
    Value::List(_) => "list"
    Value::Dict(_) => "dictionary"
  }
}

///|
/// Extract the value as a `String`. Errors if the underlying value is not a string.
pub fn Deserializer::expect_string(
  self : Deserializer,
) -> Result[String, DeserializeError] {
  match self.value {
    Value::String(s) => Ok(s)
    v => Err(DeserializeError::type_mismatch("string", value_type_name(v)))
  }
}

///|
/// Extract the value as an `Int` by parsing the string representation.
/// Errors if the value is not a string or parsing fails.
pub fn Deserializer::expect_int(
  self : Deserializer,
) -> Result[Int, DeserializeError] {
  match self.expect_string() {
    Ok(s) =>
      try @string.from_str(s.trim()) |> Ok catch {
        _ => Err(DeserializeError::parse_error(s, "Int"))
      }
    Err(e) => Err(e)
  }
}

///|
/// Extract the value as an `Int64` by parsing the string representation.
/// Errors if the value is not a string or parsing fails.
pub fn Deserializer::expect_int64(
  self : Deserializer,
) -> Result[Int64, DeserializeError] {
  match self.expect_string() {
    Ok(s) =>
      try @string.from_str(s.trim()) |> Ok catch {
        _ => Err(DeserializeError::parse_error(s, "Int64"))
      }
    Err(e) => Err(e)
  }
}

///|
/// Extract the value as a `Double` by parsing the string representation.
/// Errors if the value is not a string or parsing fails.
pub fn Deserializer::expect_double(
  self : Deserializer,
) -> Result[Double, DeserializeError] {
  match self.expect_string() {
    Ok(s) =>
      try @string.from_str(s.trim()) |> Ok catch {
        _ => Err(DeserializeError::parse_error(s, "Double"))
      }
    Err(e) => Err(e)
  }
}

///|
/// Extract the value as a `Bool`.
///
/// Accepts `true`/`True`/`TRUE`/`yes`/`Yes`/`YES` for `true`, and
/// `false`/`False`/`FALSE`/`no`/`No`/`NO` for `false`.
/// Errors if the value is not a string or the text is not a recognised
/// boolean representation.
pub fn Deserializer::expect_bool(
  self : Deserializer,
) -> Result[Bool, DeserializeError] {
  match self.expect_string() {
    Ok(s) =>
      match s.trim() {
        "true" | "True" | "TRUE" | "yes" | "Yes" | "YES" => Ok(true)
        "false" | "False" | "FALSE" | "no" | "No" | "NO" => Ok(false)
        _ => Err(DeserializeError::parse_error(s, "Bool"))
      }
    Err(e) => Err(e)
  }
}

///|
/// Extract the underlying list items.
/// Errors if the value is not a `List`.
pub fn Deserializer::expect_list(
  self : Deserializer,
) -> Result[Array[Value], DeserializeError] {
  match self.value {
    Value::List(items) => Ok(items)
    v => Err(DeserializeError::type_mismatch("list", value_type_name(v)))
  }
}

///|
/// Extract the underlying dictionary pairs.
/// Errors if the value is not a `Dict`.
pub fn Deserializer::expect_dict(
  self : Deserializer,
) -> Result[Array[(String, Value)], DeserializeError] {
  match self.value {
    Value::Dict(pairs) => Ok(pairs)
    v => Err(DeserializeError::type_mismatch("dictionary", value_type_name(v)))
  }
}

///|
/// Retrieve a field from the dictionary by key name.
/// Errors if the value is not a `Dict` or the key is missing.
pub fn Deserializer::get_field(
  self : Deserializer,
  key : String,
) -> Result[Deserializer, DeserializeError] {
  match self.expect_dict() {
    Ok(pairs) => {
      for pair in pairs {
        let (k, v) = pair
        if k == key {
          return Ok(Deserializer::new(v))
        }
      }
      Err(DeserializeError::missing_field(key))
    }
    Err(e) => Err(e)
  }
}

///|
/// Check whether a key exists in the dictionary.
/// Returns `false` if the underlying value is not a dictionary.
pub fn Deserializer::has_field(self : Deserializer, key : String) -> Bool {
  match self.value {
    Value::Dict(pairs) => {
      for pair in pairs {
        if pair.0 == key {
          return true
        }
      }
      false
    }
    _ => false
  }
}

///|
/// Return the list of field names if the value is a dictionary.
/// Returns an empty array otherwise.
pub fn Deserializer::field_names(self : Deserializer) -> Array[String] {
  match self.value {
    Value::Dict(pairs) => pairs.map(fn(p) { p.0 })
    _ => []
  }
}

///|
/// Deserialize a list where each element is decoded with `f`.
///
/// `f` receives a fresh `Deserializer` for every element.
pub fn[T] deserialize_list(
  d : Deserializer,
  f : (Deserializer) -> Result[T, DeserializeError],
) -> Result[Array[T], DeserializeError] {
  match d.expect_list() {
    Ok(items) => {
      let results : Array[T] = []
      for item in items {
        let elem_d = Deserializer::new(item)
        match f(elem_d) {
          Ok(val) => results.push(val)
          Err(e) => return Err(e)
        }
      }
      Ok(results)
    }
    Err(e) => Err(e)
  }
}

///|
/// Deserialize an optional field.
///
/// An empty string (`""`) is mapped to `None`; any other value is passed
/// through `f` and wrapped in `Some`.
pub fn[T] Deserializer::expect_optional(
  self : Deserializer,
  f : (Deserializer) -> Result[T, DeserializeError],
) -> Result[T?, DeserializeError] {
  match self.value {
    Value::String("") => Ok(None)
    _ =>
      match f(self) {
        Ok(val) => Ok(Some(val))
        Err(e) => Err(e)
      }
  }
}

///|
/// Convert a `Value` into a typed value using `f`.
pub fn[T] deserialize_value(
  value : Value,
  f : (Deserializer) -> Result[T, DeserializeError],
) -> Result[T, DeserializeError] {
  f(Deserializer::new(value))
}

///|
/// Parse a NestedText string and deserialize the result into a typed value
/// using `f`.
///
/// Parse errors (format / syntax) are returned as `NestedTextError`;
/// deserialization errors are wrapped in a `NestedTextError` with
/// `ErrorKind::DeserializationError`.
pub fn[T] deserialize_str(
  input : String,
  top : Top,
  f : (Deserializer) -> Result[T, DeserializeError],
) -> Result[T, NestedTextError] {
  match loads(input, top) {
    Ok(Some(v)) =>
      match f(Deserializer::new(v)) {
        Ok(t) => Ok(t)
        Err(e) => Err(NestedTextError::new(DeserializationError, e.message))
      }
    Ok(None) =>
      match f(Deserializer::new(Value::String(""))) {
        Ok(t) => Ok(t)
        Err(e) => Err(NestedTextError::new(DeserializationError, e.message))
      }
    Err(e) => Err(e)
  }
}
