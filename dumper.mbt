///|
/// Options for controlling NestedText output formatting.
pub(all) struct DumpOptions {
  indent : Int
  sort_keys : Bool
} derive(Debug)

///|
pub fn DumpOptions::default() -> DumpOptions {
  { indent: 4, sort_keys: false }
}

///|
/// Serialize a Value to a NestedText string.
pub fn dumps(value : Value, options : DumpOptions) -> String {
  let lines : Array[String] = []
  render_value(value, 0, options, lines)
  if lines.is_empty() {
    ""
  } else {
    lines.join("\n") + "\n"
  }
}

///|
fn render_value(
  value : Value,
  depth : Int,
  options : DumpOptions,
  lines : Array[String],
) -> Unit {
  match value {
    String(s) => render_string(s, depth, lines)
    List(items) => render_list(items, depth, options, lines)
    Dict(pairs) => render_dict(pairs, depth, options, lines)
  }
}

///|
fn render_string(s : String, depth : Int, lines : Array[String]) -> Unit {
  let indent = " ".repeat(depth)
  if s.is_empty() {
    lines.push(indent + ">")
  } else {
    for view in s.split("\n") {
      lines.push(indent + "> " + view.to_owned())
    }
  }
}

///|
fn render_list(
  items : Array[Value],
  depth : Int,
  options : DumpOptions,
  lines : Array[String],
) -> Unit {
  let indent = " ".repeat(depth)
  if items.is_empty() {
    lines.push(indent + "[]")
    return
  }
  for item in items {
    match item {
      String(s) if s.is_empty() => lines.push(indent + "-")
      String(s) if !value_needs_multiline(s) => lines.push(indent + "- " + s)
      _ => {
        lines.push(indent + "-")
        render_value(item, depth + options.indent, options, lines)
      }
    }
  }
}

///|
fn render_dict(
  pairs : Array[(String, Value)],
  depth : Int,
  options : DumpOptions,
  lines : Array[String],
) -> Unit {
  let indent = " ".repeat(depth)
  if pairs.is_empty() {
    lines.push(indent + "{}")
    return
  }
  let sorted = if options.sort_keys {
    let copy = pairs.copy()
    copy.sort_by(fn(a, b) { key_cmp(a.0, b.0) })
    copy
  } else {
    pairs
  }
  for pair in sorted {
    let (key, value) = pair
    if key_requires_multiline(key) {
      for view in key.split("\n") {
        let key_line = view.to_owned()
        if key_line.is_empty() {
          lines.push(indent + ":")
        } else {
          lines.push(indent + ": " + key_line)
        }
      }
      render_value(value, depth + options.indent, options, lines)
    } else {
      match value {
        String(s) if s.is_empty() => lines.push(indent + key + ":")
        String(s) if !value_needs_multiline(s) =>
          lines.push(indent + key + ": " + s)
        _ => {
          lines.push(indent + key + ":")
          render_value(value, depth + options.indent, options, lines)
        }
      }
    }
  }
}

///|
fn key_requires_multiline(key : String) -> Bool {
  if key.is_empty() || key.contains("\n") {
    return true
  }
  let trimmed = key.trim().to_owned()
  if trimmed != key {
    return true
  }
  if key.contains(": ") || key.has_suffix(":") {
    return true
  }
  if key.has_prefix("- ") ||
    key == "-" ||
    key.has_prefix("> ") ||
    key == ">" ||
    key.has_prefix(": ") ||
    key == ":" ||
    key.has_prefix("#") ||
    key.has_prefix("[") ||
    key.has_prefix("{") {
    return true
  }
  false
}

///|
fn value_needs_multiline(s : String) -> Bool {
  if s.contains("\n") {
    return true
  }
  if !s.is_empty() {
    let trimmed = s.trim().to_owned()
    if trimmed != s {
      return true
    }
  }
  false
}

///|
fn key_cmp(a : String, b : String) -> Int {
  if a > b {
    1
  } else if a < b {
    -1
  } else {
    0
  }
}
