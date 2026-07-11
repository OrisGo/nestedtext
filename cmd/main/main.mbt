///|
fn main {
  let args = @env.args()
  let file_args = args.filter(fn(a) {
    !(a.contains(".wasm") || a.contains(".moon\\bin"))
  })
  if file_args.length() == 0 {
    println("usage: moon run cmd/main -- <file.nt>")
    return
  }
  let path = file_args[0]
  let content = @fs.read_file_to_string(path) catch {
    @fs.IOError(msg) => {
      println("error: failed to read '\{path}': \{msg}")
      return
    }
  }
  let top = parse_top()
  let line_count = count_lines(content)
  println("=== \{path} ===")
  let start = @env.now()
  match @nestedtext.loads(content, top) {
    Ok(Some(value)) => {
      let elapsed = @env.now() - start
      let out_path = path + ".out"
      let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
      @fs.write_string_to_file(out_path, output) catch {
        @fs.IOError(msg) =>
          println("error: failed to write '\{out_path}': \{msg}")
      }
      println("PASS | \{line_count} lines | \{elapsed}ms | -> \{out_path}")
    }
    Ok(None) => {
      let elapsed = @env.now() - start
      println("PASS | empty | \{elapsed}ms")
    }
    Err(e) => {
      let elapsed = @env.now() - start
      let top_label = top_label(top)
      println("FAIL | \{line_count} lines | \{elapsed}ms | Top::\{top_label}")
      print_error_ctx(content, e)
    }
  }
}

///|
fn print_error_ctx(content : String, e : @nestedtext.NestedTextError) -> Unit {
  match e.lineno {
    Some(lineno) => {
      println("")
      let line = get_line(content, lineno)
      println("  \{e.to_string()}")
      if line != "" {
        println("  \{lineno} | \{line}")
      }
      match e.colno {
        Some(colno) => {
          let indicator = spaces(colno) + "^"
          println("  \{indicator}")
        }
        None => ()
      }
    }
    None => println("  \{e.to_string()}")
  }
  println("")
}

///|
fn get_line(content : String, lineno : Int) -> String {
  let lines = content.split("\n").to_array()
  for i, view in lines {
    if i + 1 == lineno {
      return view.to_owned()
    }
  }
  ""
}

///|
fn spaces(n : Int) -> String {
  let buf = StringBuilder::new()
  for _ in 0..<n {
    buf.write_char(' ')
  }
  buf.to_string()
}

///|
fn count_lines(content : String) -> Int {
  content.split("\n").length()
}

///|
fn parse_top() -> @nestedtext.Top {
  match @env.get_env_var("NESTEDTEXT_TOP") {
    Some("dict") => @nestedtext.Top::Dict
    Some("list") => @nestedtext.Top::List
    Some("string") => @nestedtext.Top::String
    _ => @nestedtext.Top::Any
  }
}

///|
fn top_label(top : @nestedtext.Top) -> String {
  match top {
    @nestedtext.Top::Dict => "Dict"
    @nestedtext.Top::List => "List"
    @nestedtext.Top::String => "String"
    @nestedtext.Top::Any => "Any"
  }
}
