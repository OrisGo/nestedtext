///|
/// The three NestedText value types.
///
/// NestedText has string scalars, lists, and dictionaries. Dictionaries keep
/// insertion order by storing key-value pairs in an array.
pub(all) enum Value {
  String(String)
  List(Array[Value])
  Dict(Array[(String, Value)])
} derive(Debug, Eq)

///|
pub fn Value::is_string(self : Value) -> Bool {
  match self {
    String(_) => true
    _ => false
  }
}

///|
pub fn Value::is_list(self : Value) -> Bool {
  match self {
    List(_) => true
    _ => false
  }
}

///|
pub fn Value::is_dict(self : Value) -> Bool {
  match self {
    Dict(_) => true
    _ => false
  }
}

///|
pub fn Value::as_string(self : Value) -> String? {
  match self {
    String(s) => Some(s)
    _ => None
  }
}

///|
pub fn Value::as_list(self : Value) -> Array[Value]? {
  match self {
    List(items) => Some(items)
    _ => None
  }
}

///|
pub fn Value::as_dict(self : Value) -> Array[(String, Value)]? {
  match self {
    Dict(pairs) => Some(pairs)
    _ => None
  }
}

///|
pub fn Value::get(self : Value, key : String) -> Value? {
  match self {
    Dict(pairs) => {
      for pair in pairs {
        let (k, v) = pair
        if k == key {
          return Some(v)
        }
      }
      None
    }
    _ => None
  }
}
