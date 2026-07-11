///|
fn json_escape(s : String) -> String {
  let buf = StringBuilder::new()
  for ch in s {
    match ch {
      '\"' => buf.write_string("\\\"")
      '\\' => buf.write_string("\\\\")
      '\n' => buf.write_string("\\n")
      '\r' => buf.write_string("\\r")
      '\t' => buf.write_string("\\t")
      _ => buf.write_char(ch)
    }
  }
  buf.to_string()
}

///|
fn value_to_json(value : Value) -> String {
  match value {
    String(s) => {
      let buf = StringBuilder::new()
      buf.write_string("\"")
      buf.write_string(json_escape(s))
      buf.write_string("\"")
      buf.to_string()
    }
    List(items) => {
      let buf = StringBuilder::new()
      buf.write_string("[")
      for i = 0; i < items.length(); i = i + 1 {
        if i > 0 {
          buf.write_string(",")
        }
        buf.write_string(value_to_json(items[i]))
      }
      buf.write_string("]")
      buf.to_string()
    }
    Dict(pairs) => {
      let buf = StringBuilder::new()
      buf.write_string("{")
      for i = 0; i < pairs.length(); i = i + 1 {
        if i > 0 {
          buf.write_string(",")
        }
        let (k, v) = pairs[i]
        buf.write_string("\"")
        buf.write_string(json_escape(k))
        buf.write_string("\":")
        buf.write_string(value_to_json(v))
      }
      buf.write_string("}")
      buf.to_string()
    }
  }
}

///|
pub fn loads_to_json(input : String) -> String {
  match loads(input, Top::Any) {
    Ok(None) => "{\"status\":\"ok\",\"value\":null}"
    Ok(Some(value)) => {
      let buf = StringBuilder::new()
      buf.write_string("{\"status\":\"ok\",\"value\":")
      buf.write_string(value_to_json(value))
      buf.write_string("}")
      buf.to_string()
    }
    Err(err) => {
      let buf = StringBuilder::new()
      buf.write_string("{\"status\":\"err\",\"message\":\"")
      buf.write_string(json_escape(err.to_string()))
      buf.write_string("\"}")
      buf.to_string()
    }
  }
}
