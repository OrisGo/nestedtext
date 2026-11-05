///|
/// Error returned when deserialization of a `Value` into a typed target fails.
#derive(Debug, Eq)
pub(all) struct DeserializeError {
  message : String
}

///|
pub extend DeserializeError with @debug.Debug::{to_repr}

///|
pub extend DeserializeError with Eq::{equal, not_equal}

///|
/// Create a `DeserializeError` with a free-form message.
pub fn DeserializeError::new(message : String) -> DeserializeError {
  { message, }
}

///|
/// Create an error for a type mismatch (e.g. expected a list but got a string).
pub fn DeserializeError::type_mismatch(
  expected : String,
  actual : String,
) -> DeserializeError {
  { message: "expected \{expected}, got \{actual}", }
}

///|
/// Create an error for a failed string-to-primitive conversion.
pub fn DeserializeError::parse_error(
  value : String,
  target_type : String,
) -> DeserializeError {
  { message: "cannot parse '\{value}' as \{target_type}", }
}

///|
/// Create an error for a missing dictionary field.
pub fn DeserializeError::missing_field(field_name : String) -> DeserializeError {
  { message: "missing field: \{field_name}", }
}

///|
/// A typed view over a parsed `Value` that extracts MoonBit values.
#derive(Debug, Eq)
pub(all) struct Deserializer {
  value : Value
}

///|
pub extend Deserializer with @debug.Debug::{to_repr}

///|
pub extend Deserializer with Eq::{equal, not_equal}

///|
/// Wrap a `Value` for typed extraction.
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
/// Extract the value as an `Int32` by parsing the string representation.
///
/// # Errors
/// Returns `DeserializeError::type_mismatch` when the value is not a string,
/// or `DeserializeError::parse_error` when the string cannot be parsed as
/// an `Int32`.
pub fn Deserializer::expect_int(
  self : Deserializer,
) -> Result[Int32, DeserializeError] {
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
///
/// # Errors
/// Returns `DeserializeError::type_mismatch` when the value is not a string,
/// or `DeserializeError::parse_error` when the string cannot be parsed as
/// an `Int64`.
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
///
/// # Errors
/// Returns `DeserializeError::type_mismatch` when the value is not a string,
/// or `DeserializeError::parse_error` when the string cannot be parsed as
/// a `Double`.
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
/// # Parameters
/// * `d` — A deserializer that should wrap a `List` value.
/// * `f` — A function that receives a fresh `Deserializer` for each element.
///
/// # Returns
/// The array of decoded elements on success.
/// Returns `DeserializeError::type_mismatch` when the underlying value is not
/// a list.
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
///
/// # Parameters
/// * `value` — The parsed value to deserialize.
/// * `f` — A function that extracts the typed result from a `Deserializer`.
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
