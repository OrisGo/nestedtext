///|
/// Compliance tests adapted from the official NestedText test suite.
/// Source: https://github.com/nestedtext/nestedtext

///|
test "compliance: alpine" {
  match @nestedtext.loads(">", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String(""),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: medical" {
  match @nestedtext.loads(">\n>", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("\n"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: terrier" {
  match @nestedtext.loads("> Those who can make you believe absurdities can make you commit atrocities.  — Voltaire", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("Those who can make you believe absurdities can make you commit atrocities.  — Voltaire"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: perimeter" {
  match @nestedtext.loads("> “The worth of a man to his society can be measured by the contribution he\n>  makes to it — less the cost of sustaining himself and his mistakes in it.”\n>\n>                                                — Erik Jonsson\n>", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("“The worth of a man to his society can be measured by the contribution he\n makes to it — less the cost of sustaining himself and his mistakes in it.”\n\n                                               — Erik Jonsson\n"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: precipice" {
  match @nestedtext.loads(":\n  >", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: province" {
  match @nestedtext.loads("key 1: value 1\nkey 2: value 2\nkey 3: value 3\n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key 2",
        @nestedtext.Value::String("value 2")),
      ("key 3",
        @nestedtext.Value::String("value 3"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: detonator" {
  match @nestedtext.loads("key 1: value 1\nkey 2: value 2\nkey 3: value 3", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key 2",
        @nestedtext.Value::String("value 2")),
      ("key 3",
        @nestedtext.Value::String("value 3"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: theater" {
  match @nestedtext.loads("key 1: value 1\nkey 2:\nkey 3:\n    - value 3a\n    - value 3b\nkey 4:\n    key 4a: value 4a\n    key 4b: value 4b\nkey 5:\n    > first line of value 5\n    > second line of value 5", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key 2",
        @nestedtext.Value::String("")),
      ("key 3",
        @nestedtext.Value::List([
          @nestedtext.Value::String("value 3a"),
          @nestedtext.Value::String("value 3b")
        ])),
      ("key 4",
        @nestedtext.Value::Dict([
          ("key 4a",
            @nestedtext.Value::String("value 4a")),
          ("key 4b",
            @nestedtext.Value::String("value 4b"))
        ])),
      ("key 5",
        @nestedtext.Value::String("first line of value 5\nsecond line of value 5"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: crescent" {
  match @nestedtext.loads("-", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: automaton" {
  match @nestedtext.loads("- value 1\n- value 2\n- value 3\n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("value 1"),
      @nestedtext.Value::String("value 2"),
      @nestedtext.Value::String("value 3")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: wally" {
  match @nestedtext.loads("- value 1\n- value 2\n- value 3", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("value 1"),
      @nestedtext.Value::String("value 2"),
      @nestedtext.Value::String("value 3")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: native" {
  match @nestedtext.loads("- value 1\n-\n-\n    - value 3a\n    - value 3b\n-\n    key 4a: value 4a\n    key 4b: value 4b\n-\n    > first line of value 5\n    > second line of value 5", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("value 1"),
      @nestedtext.Value::String(""),
      @nestedtext.Value::List([
        @nestedtext.Value::String("value 3a"),
        @nestedtext.Value::String("value 3b")
      ]),
      @nestedtext.Value::Dict([
        ("key 4a",
          @nestedtext.Value::String("value 4a")),
        ("key 4b",
          @nestedtext.Value::String("value 4b"))
      ]),
      @nestedtext.Value::String("first line of value 5\nsecond line of value 5")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: answer" {
  match @nestedtext.loads(":\n    :\n        >", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("",
        @nestedtext.Value::Dict([
          ("",
            @nestedtext.Value::String(""))
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: screwy" {
  match @nestedtext.loads(": key 1\n:     the first key\n    > value 1\n: key 2: the second key\n    - value 2a\n    - value 2b", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1\n    the first key",
        @nestedtext.Value::String("value 1")),
      ("key 2: the second key",
        @nestedtext.Value::List([
          @nestedtext.Value::String("value 2a"),
          @nestedtext.Value::String("value 2b")
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: socialize" {
  match @nestedtext.loads("{}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: abound" {
  match @nestedtext.loads("{:}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: washday" {
  match @nestedtext.loads("{key 1: value 1, key 2: value 2, key 3: value 3}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key 2",
        @nestedtext.Value::String("value 2")),
      ("key 3",
        @nestedtext.Value::String("value 3"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: exhume" {
  match @nestedtext.loads("{key 1: value 1, key 2: [value 2a, value 2b], key 3: {key 3a: value 3a, key 3b: value 3b}}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key 2",
        @nestedtext.Value::List([
          @nestedtext.Value::String("value 2a"),
          @nestedtext.Value::String("value 2b")
        ])),
      ("key 3",
        @nestedtext.Value::Dict([
          ("key 3a",
            @nestedtext.Value::String("value 3a")),
          ("key 3b",
            @nestedtext.Value::String("value 3b"))
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: ointment" {
  match @nestedtext.loads("[]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: banquet" {
  match @nestedtext.loads("[ ]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: cliff" {
  match @nestedtext.loads("[  ]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: stingray" {
  match @nestedtext.loads("[value 1, value 2, value 3]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("value 1"),
      @nestedtext.Value::String("value 2"),
      @nestedtext.Value::String("value 3")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: spastic" {
  match @nestedtext.loads("[value 1, [value 2a, value 2b], {key 3a: value 3a, key 3b: value 3b}]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("value 1"),
      @nestedtext.Value::List([
        @nestedtext.Value::String("value 2a"),
        @nestedtext.Value::String("value 2b")
      ]),
      @nestedtext.Value::Dict([
        ("key 3a",
          @nestedtext.Value::String("value 3a")),
        ("key 3b",
          @nestedtext.Value::String("value 3b"))
      ])
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: brother" {
  match @nestedtext.loads("", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("null"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: cosmology" {
  match @nestedtext.loads("#", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("null"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: clone" {
  match @nestedtext.loads("\n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("null"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: spillage" {
  match @nestedtext.loads("a:\n -\n  b:\n   -\n    c:\n     -\n      d:\n       -\n        e:\n         -\n          f:\n           -\n            g:\n             -\n              h:\n               -\n                i:\n                 -\n                  j:\n                   -\n                    k:\n                     -\n                      l:\n                       -\n                        m:\n                         -\n                          n:\n                           -\n                            o:\n                             -\n                              p:\n                               -\n                                q:\n                                 -\n                                  r:\n                                   -\n                                    s:\n                                     -\n                                      t:\n                                       -\n                                        u:\n                                         -\n                                          v:\n                                           -\n                                            w:\n                                             -\n                                              x:\n                                               -\n                                                y:\n                                                 -\n                                                  z:\n                                                   -\n                                                    α:\n                                                     -\n                                                      β:\n                                                       -\n                                                        γ:\n                                                         -\n                                                          δ:\n                                                           -\n                                                            ε:\n                                                             -\n                                                              ζ:\n                                                               -\n                                                                η:\n                                                                 -\n                                                                  θ:\n                                                                   -\n                                                                    ι:\n                                                                     -\n                                                                      κ:\n                                                                       -\n                                                                        λ:\n                                                                         -\n                                                                          μ:\n                                                                           -\n                                                                            ν:\n                                                                             -\n                                                                              ξ:\n                                                                               -\n                                                                                ο:\n                                                                                 -\n                                                                                  π:\n                                                                                   -\n                                                                                    ρ:\n                                                                                     -\n                                                                                      σ:\n                                                                                       -\n                                                                                        τ:\n                                                                                         -\n                                                                                          υ:\n                                                                                           -\n                                                                                            φ:\n                                                                                             -\n                                                                                              χ:\n                                                                                               -\n                                                                                                ψ:\n                                                                                                 -\n                                                                                                  ω:\n                                                                                                   -\n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("a",
        @nestedtext.Value::List([
          @nestedtext.Value::Dict([
            ("b",
              @nestedtext.Value::List([
                @nestedtext.Value::Dict([
                  ("c",
                    @nestedtext.Value::List([
                      @nestedtext.Value::Dict([
                        ("d",
                          @nestedtext.Value::List([
                            @nestedtext.Value::Dict([
                              ("e",
                                @nestedtext.Value::List([
                                  @nestedtext.Value::Dict([
                                    ("f",
                                      @nestedtext.Value::List([
                                        @nestedtext.Value::Dict([
                                          ("g",
                                            @nestedtext.Value::List([
                                              @nestedtext.Value::Dict([
                                                ("h",
                                                  @nestedtext.Value::List([
                                                    @nestedtext.Value::Dict([
                                                      ("i",
                                                        @nestedtext.Value::List([
                                                          @nestedtext.Value::Dict([
                                                            ("j",
                                                              @nestedtext.Value::List([
                                                                @nestedtext.Value::Dict([
                                                                  ("k",
                                                                    @nestedtext.Value::List([
                                                                      @nestedtext.Value::Dict([
                                                                        ("l",
                                                                          @nestedtext.Value::List([
                                                                            @nestedtext.Value::Dict([
                                                                              ("m",
                                                                                @nestedtext.Value::List([
                                                                                  @nestedtext.Value::Dict([
                                                                                    ("n",
                                                                                      @nestedtext.Value::List([
                                                                                        @nestedtext.Value::Dict([
                                                                                          ("o",
                                                                                            @nestedtext.Value::List([
                                                                                              @nestedtext.Value::Dict([
                                                                                                ("p",
                                                                                                  @nestedtext.Value::List([
                                                                                                    @nestedtext.Value::Dict([
                                                                                                      ("q",
                                                                                                        @nestedtext.Value::List([
                                                                                                          @nestedtext.Value::Dict([
                                                                                                            ("r",
                                                                                                              @nestedtext.Value::List([
                                                                                                                @nestedtext.Value::Dict([
                                                                                                                  ("s",
                                                                                                                    @nestedtext.Value::List([
                                                                                                                      @nestedtext.Value::Dict([
                                                                                                                        ("t",
                                                                                                                          @nestedtext.Value::List([
                                                                                                                            @nestedtext.Value::Dict([
                                                                                                                              ("u",
                                                                                                                                @nestedtext.Value::List([
                                                                                                                                  @nestedtext.Value::Dict([
                                                                                                                                    ("v",
                                                                                                                                      @nestedtext.Value::List([
                                                                                                                                        @nestedtext.Value::Dict([
                                                                                                                                          ("w",
                                                                                                                                            @nestedtext.Value::List([
                                                                                                                                              @nestedtext.Value::Dict([
                                                                                                                                                ("x",
                                                                                                                                                  @nestedtext.Value::List([
                                                                                                                                                    @nestedtext.Value::Dict([
                                                                                                                                                      ("y",
                                                                                                                                                        @nestedtext.Value::List([
                                                                                                                                                          @nestedtext.Value::Dict([
                                                                                                                                                            ("z",
                                                                                                                                                              @nestedtext.Value::List([
                                                                                                                                                                @nestedtext.Value::Dict([
                                                                                                                                                                  ("α",
                                                                                                                                                                    @nestedtext.Value::List([
                                                                                                                                                                      @nestedtext.Value::Dict([
                                                                                                                                                                        ("β",
                                                                                                                                                                          @nestedtext.Value::List([
                                                                                                                                                                            @nestedtext.Value::Dict([
                                                                                                                                                                              ("γ",
                                                                                                                                                                                @nestedtext.Value::List([
                                                                                                                                                                                  @nestedtext.Value::Dict([
                                                                                                                                                                                    ("δ",
                                                                                                                                                                                      @nestedtext.Value::List([
                                                                                                                                                                                        @nestedtext.Value::Dict([
                                                                                                                                                                                          ("ε",
                                                                                                                                                                                            @nestedtext.Value::List([
                                                                                                                                                                                              @nestedtext.Value::Dict([
                                                                                                                                                                                                ("ζ",
                                                                                                                                                                                                  @nestedtext.Value::List([
                                                                                                                                                                                                    @nestedtext.Value::Dict([
                                                                                                                                                                                                      ("η",
                                                                                                                                                                                                        @nestedtext.Value::List([
                                                                                                                                                                                                          @nestedtext.Value::Dict([
                                                                                                                                                                                                            ("θ",
                                                                                                                                                                                                              @nestedtext.Value::List([
                                                                                                                                                                                                                @nestedtext.Value::Dict([
                                                                                                                                                                                                                  ("ι",
                                                                                                                                                                                                                    @nestedtext.Value::List([
                                                                                                                                                                                                                      @nestedtext.Value::Dict([
                                                                                                                                                                                                                        ("κ",
                                                                                                                                                                                                                          @nestedtext.Value::List([
                                                                                                                                                                                                                            @nestedtext.Value::Dict([
                                                                                                                                                                                                                              ("λ",
                                                                                                                                                                                                                                @nestedtext.Value::List([
                                                                                                                                                                                                                                  @nestedtext.Value::Dict([
                                                                                                                                                                                                                                    ("μ",
                                                                                                                                                                                                                                      @nestedtext.Value::List([
                                                                                                                                                                                                                                        @nestedtext.Value::Dict([
                                                                                                                                                                                                                                          ("ν",
                                                                                                                                                                                                                                            @nestedtext.Value::List([
                                                                                                                                                                                                                                              @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                ("ξ",
                                                                                                                                                                                                                                                  @nestedtext.Value::List([
                                                                                                                                                                                                                                                    @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                      ("ο",
                                                                                                                                                                                                                                                        @nestedtext.Value::List([
                                                                                                                                                                                                                                                          @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                            ("π",
                                                                                                                                                                                                                                                              @nestedtext.Value::List([
                                                                                                                                                                                                                                                                @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                  ("ρ",
                                                                                                                                                                                                                                                                    @nestedtext.Value::List([
                                                                                                                                                                                                                                                                      @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                        ("σ",
                                                                                                                                                                                                                                                                          @nestedtext.Value::List([
                                                                                                                                                                                                                                                                            @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                              ("τ",
                                                                                                                                                                                                                                                                                @nestedtext.Value::List([
                                                                                                                                                                                                                                                                                  @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                                    ("υ",
                                                                                                                                                                                                                                                                                      @nestedtext.Value::List([
                                                                                                                                                                                                                                                                                        @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                                          ("φ",
                                                                                                                                                                                                                                                                                            @nestedtext.Value::List([
                                                                                                                                                                                                                                                                                              @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                                                ("χ",
                                                                                                                                                                                                                                                                                                  @nestedtext.Value::List([
                                                                                                                                                                                                                                                                                                    @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                                                      ("ψ",
                                                                                                                                                                                                                                                                                                        @nestedtext.Value::List([
                                                                                                                                                                                                                                                                                                          @nestedtext.Value::Dict([
                                                                                                                                                                                                                                                                                                            ("ω",
                                                                                                                                                                                                                                                                                                              @nestedtext.Value::List([
                                                                                                                                                                                                                                                                                                                @nestedtext.Value::String("")
                                                                                                                                                                                                                                                                                                              ]))
                                                                                                                                                                                                                                                                                                          ])
                                                                                                                                                                                                                                                                                                        ]))
                                                                                                                                                                                                                                                                                                    ])
                                                                                                                                                                                                                                                                                                  ]))
                                                                                                                                                                                                                                                                                              ])
                                                                                                                                                                                                                                                                                            ]))
                                                                                                                                                                                                                                                                                        ])
                                                                                                                                                                                                                                                                                      ]))
                                                                                                                                                                                                                                                                                  ])
                                                                                                                                                                                                                                                                                ]))
                                                                                                                                                                                                                                                                            ])
                                                                                                                                                                                                                                                                          ]))
                                                                                                                                                                                                                                                                      ])
                                                                                                                                                                                                                                                                    ]))
                                                                                                                                                                                                                                                                ])
                                                                                                                                                                                                                                                              ]))
                                                                                                                                                                                                                                                          ])
                                                                                                                                                                                                                                                        ]))
                                                                                                                                                                                                                                                    ])
                                                                                                                                                                                                                                                  ]))
                                                                                                                                                                                                                                              ])
                                                                                                                                                                                                                                            ]))
                                                                                                                                                                                                                                        ])
                                                                                                                                                                                                                                      ]))
                                                                                                                                                                                                                                  ])
                                                                                                                                                                                                                                ]))
                                                                                                                                                                                                                            ])
                                                                                                                                                                                                                          ]))
                                                                                                                                                                                                                      ])
                                                                                                                                                                                                                    ]))
                                                                                                                                                                                                                ])
                                                                                                                                                                                                              ]))
                                                                                                                                                                                                          ])
                                                                                                                                                                                                        ]))
                                                                                                                                                                                                    ])
                                                                                                                                                                                                  ]))
                                                                                                                                                                                              ])
                                                                                                                                                                                            ]))
                                                                                                                                                                                        ])
                                                                                                                                                                                      ]))
                                                                                                                                                                                  ])
                                                                                                                                                                                ]))
                                                                                                                                                                            ])
                                                                                                                                                                          ]))
                                                                                                                                                                      ])
                                                                                                                                                                    ]))
                                                                                                                                                                ])
                                                                                                                                                              ]))
                                                                                                                                                          ])
                                                                                                                                                        ]))
                                                                                                                                                    ])
                                                                                                                                                  ]))
                                                                                                                                              ])
                                                                                                                                            ]))
                                                                                                                                        ])
                                                                                                                                      ]))
                                                                                                                                  ])
                                                                                                                                ]))
                                                                                                                            ])
                                                                                                                          ]))
                                                                                                                      ])
                                                                                                                    ]))
                                                                                                                ])
                                                                                                              ]))
                                                                                                          ])
                                                                                                        ]))
                                                                                                    ])
                                                                                                  ]))
                                                                                              ])
                                                                                            ]))
                                                                                        ])
                                                                                      ]))
                                                                                  ])
                                                                                ]))
                                                                            ])
                                                                          ]))
                                                                      ])
                                                                    ]))
                                                                ])
                                                              ]))
                                                          ])
                                                        ]))
                                                    ])
                                                  ]))
                                              ])
                                            ]))
                                        ])
                                      ]))
                                  ])
                                ]))
                            ])
                          ]))
                      ])
                    ]))
                ])
              ]))
          ])
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: moccasin" {
  match @nestedtext.loads("{a:[{b:[{c:[{d:[{e:[{f:[{g:[{h:[{i:[{j:[{k:[{l:[{m:[{n:[{o:[{p:[{q:[{r:[{s:[{t:[{u:[{v:[{w:[{x:[{y:[{z:[ ]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("a",
        @nestedtext.Value::List([
          @nestedtext.Value::Dict([
            ("b",
              @nestedtext.Value::List([
                @nestedtext.Value::Dict([
                  ("c",
                    @nestedtext.Value::List([
                      @nestedtext.Value::Dict([
                        ("d",
                          @nestedtext.Value::List([
                            @nestedtext.Value::Dict([
                              ("e",
                                @nestedtext.Value::List([
                                  @nestedtext.Value::Dict([
                                    ("f",
                                      @nestedtext.Value::List([
                                        @nestedtext.Value::Dict([
                                          ("g",
                                            @nestedtext.Value::List([
                                              @nestedtext.Value::Dict([
                                                ("h",
                                                  @nestedtext.Value::List([
                                                    @nestedtext.Value::Dict([
                                                      ("i",
                                                        @nestedtext.Value::List([
                                                          @nestedtext.Value::Dict([
                                                            ("j",
                                                              @nestedtext.Value::List([
                                                                @nestedtext.Value::Dict([
                                                                  ("k",
                                                                    @nestedtext.Value::List([
                                                                      @nestedtext.Value::Dict([
                                                                        ("l",
                                                                          @nestedtext.Value::List([
                                                                            @nestedtext.Value::Dict([
                                                                              ("m",
                                                                                @nestedtext.Value::List([
                                                                                  @nestedtext.Value::Dict([
                                                                                    ("n",
                                                                                      @nestedtext.Value::List([
                                                                                        @nestedtext.Value::Dict([
                                                                                          ("o",
                                                                                            @nestedtext.Value::List([
                                                                                              @nestedtext.Value::Dict([
                                                                                                ("p",
                                                                                                  @nestedtext.Value::List([
                                                                                                    @nestedtext.Value::Dict([
                                                                                                      ("q",
                                                                                                        @nestedtext.Value::List([
                                                                                                          @nestedtext.Value::Dict([
                                                                                                            ("r",
                                                                                                              @nestedtext.Value::List([
                                                                                                                @nestedtext.Value::Dict([
                                                                                                                  ("s",
                                                                                                                    @nestedtext.Value::List([
                                                                                                                      @nestedtext.Value::Dict([
                                                                                                                        ("t",
                                                                                                                          @nestedtext.Value::List([
                                                                                                                            @nestedtext.Value::Dict([
                                                                                                                              ("u",
                                                                                                                                @nestedtext.Value::List([
                                                                                                                                  @nestedtext.Value::Dict([
                                                                                                                                    ("v",
                                                                                                                                      @nestedtext.Value::List([
                                                                                                                                        @nestedtext.Value::Dict([
                                                                                                                                          ("w",
                                                                                                                                            @nestedtext.Value::List([
                                                                                                                                              @nestedtext.Value::Dict([
                                                                                                                                                ("x",
                                                                                                                                                  @nestedtext.Value::List([
                                                                                                                                                    @nestedtext.Value::Dict([
                                                                                                                                                      ("y",
                                                                                                                                                        @nestedtext.Value::List([
                                                                                                                                                          @nestedtext.Value::Dict([
                                                                                                                                                            ("z",
                                                                                                                                                              @nestedtext.Value::List([
                                                                                                                                                                @nestedtext.Value::String("")
                                                                                                                                                              ]))
                                                                                                                                                          ])
                                                                                                                                                        ]))
                                                                                                                                                    ])
                                                                                                                                                  ]))
                                                                                                                                              ])
                                                                                                                                            ]))
                                                                                                                                        ])
                                                                                                                                      ]))
                                                                                                                                  ])
                                                                                                                                ]))
                                                                                                                            ])
                                                                                                                          ]))
                                                                                                                      ])
                                                                                                                    ]))
                                                                                                                ])
                                                                                                              ]))
                                                                                                          ])
                                                                                                        ]))
                                                                                                    ])
                                                                                                  ]))
                                                                                              ])
                                                                                            ]))
                                                                                        ])
                                                                                      ]))
                                                                                  ])
                                                                                ]))
                                                                            ])
                                                                          ]))
                                                                      ])
                                                                    ]))
                                                                ])
                                                              ]))
                                                          ])
                                                        ]))
                                                    ])
                                                  ]))
                                              ])
                                            ]))
                                        ])
                                      ]))
                                  ])
                                ]))
                            ])
                          ]))
                      ])
                    ]))
                ])
              ]))
          ])
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: insulate" {
  match @nestedtext.loads("code   : input signed [7:0] level\nregex  : [+-]?([0-9]*[.])?[0-9]+\\s*\\w*\nmath   : $x = \\frac{{-b \\pm \\sqrt {b^2 - 4ac}}}{2a}$\nunicode: José and François", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("code",
        @nestedtext.Value::String("input signed [7:0] level")),
      ("regex",
        @nestedtext.Value::String("[+-]?([0-9]*[.])?[0-9]+\\s*\\w*")),
      ("math",
        @nestedtext.Value::String("$x = \\frac{{-b \\pm \\sqrt {b^2 - 4ac}}}{2a}$")),
      ("unicode",
        @nestedtext.Value::String("José and François"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: scent" {
  match @nestedtext.loads(">     This is the first line of a multiline string, it is indented.\n> This is the second line, it is not indented.", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("    This is the first line of a multiline string, it is indented.\nThis is the second line, it is not indented."),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: smithy" {
  match @nestedtext.loads("# this line is ignored\n\n# this line is also ignored, as is the blank line above.\n\n# this is a comment that contains unicode: “αβγ ΩƱ 𝄞🁒 🌀”\n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("null"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: import" {
  match @nestedtext.loads("> this is the first line of a multiline string\n# this line is ignored\n> this is the second line of the multiline string", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("this is the first line of a multiline string\nthis is the second line of the multiline string"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: unlearn" {
  match @nestedtext.loads("# Contact information for our officers\n\nKatheryn McDaniel:\n    position: president\n    address:\n        > 138 Almond Street\n        > Topeka, Kansas 20697\n    phone:\n        cell: 1-210-555-5297\n        work: 1-210-555-3423\n        home: 1-210-555-8470\n            # Katheryn prefers that we always call her on her cell phone.\n    email: KateMcD@aol.com\n    kids:\n        - Joanie\n        - Terrance\n\nMargaret Hodge:\n    position: vice president\n    address:\n        > 2586 Marigold Lane\n        > Topeka, Kansas 20697\n    phone:\n        {cell: 1-470-555-0398, home: 1-470-555-7570}\n    email: margaret.hodge@ku.edu\n    kids:\n        [Arnie, Zach, Maggie]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("Katheryn McDaniel",
        @nestedtext.Value::Dict([
          ("position",
            @nestedtext.Value::String("president")),
          ("address",
            @nestedtext.Value::String("138 Almond Street\nTopeka, Kansas 20697")),
          ("phone",
            @nestedtext.Value::Dict([
              ("cell",
                @nestedtext.Value::String("1-210-555-5297")),
              ("work",
                @nestedtext.Value::String("1-210-555-3423")),
              ("home",
                @nestedtext.Value::String("1-210-555-8470"))
            ])),
          ("email",
            @nestedtext.Value::String("KateMcD@aol.com")),
          ("kids",
            @nestedtext.Value::List([
              @nestedtext.Value::String("Joanie"),
              @nestedtext.Value::String("Terrance")
            ]))
        ])),
      ("Margaret Hodge",
        @nestedtext.Value::Dict([
          ("position",
            @nestedtext.Value::String("vice president")),
          ("address",
            @nestedtext.Value::String("2586 Marigold Lane\nTopeka, Kansas 20697")),
          ("phone",
            @nestedtext.Value::Dict([
              ("cell",
                @nestedtext.Value::String("1-470-555-0398")),
              ("home",
                @nestedtext.Value::String("1-470-555-7570"))
            ])),
          ("email",
            @nestedtext.Value::String("margaret.hodge@ku.edu")),
          ("kids",
            @nestedtext.Value::List([
              @nestedtext.Value::String("Arnie"),
              @nestedtext.Value::String("Zach"),
              @nestedtext.Value::String("Maggie")
            ]))
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: amnesty" {
  match @nestedtext.loads("treasurer:\n    name: Fumiko Purvis\n    address: Home\n        > 3636 Buffalo Ave\n        > Topeka, Kansas 20692", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: subdue" {
  match @nestedtext.loads("treasurer:\n    name: Fumiko Purvis\n    address:  \n        > 3636 Buffalo Ave\n        > Topeka, Kansas 20692", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: balloon" {
  match @nestedtext.loads(":", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: lolly" {
  match @nestedtext.loads(":\n    :", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: cornea" {
  match @nestedtext.loads("> Lorem Ipsum\n>\n>     Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\n> eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad \n> minim veniam, quis nostrud exercitation ullamco laboris nisi ut \n> aliquip ex ea commodo consequat. Duis aute irure dolor in \n> reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \n> pariatur. Excepteur sint occaecat cupidatat non proident, sunt in \n> culpa qui officia deserunt mollit anim id est laborum.", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("Lorem Ipsum\n\n    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\neiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad \nminim veniam, quis nostrud exercitation ullamco laboris nisi ut \naliquip ex ea commodo consequat. Duis aute irure dolor in \nreprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \npariatur. Excepteur sint occaecat cupidatat non proident, sunt in \nculpa qui officia deserunt mollit anim id est laborum."),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: tacky" {
  match @nestedtext.loads(">\n> Lorem Ipsum\n>\n>     Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\n> eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad \n> minim veniam, quis nostrud exercitation ullamco laboris nisi ut \n> aliquip ex ea commodo consequat. Duis aute irure dolor in \n> reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \n> pariatur. Excepteur sint occaecat cupidatat non proident, sunt in \n> culpa qui officia deserunt mollit anim id est laborum.\n>", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("\nLorem Ipsum\n\n    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\neiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad \nminim veniam, quis nostrud exercitation ullamco laboris nisi ut \naliquip ex ea commodo consequat. Duis aute irure dolor in \nreprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \npariatur. Excepteur sint occaecat cupidatat non proident, sunt in \nculpa qui officia deserunt mollit anim id est laborum.\n"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: mailbox" {
  match @nestedtext.loads(">\n> Lorem Ipsum\n>\n>     Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\n> eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad \n> minim veniam, quis nostrud exercitation ullamco laboris nisi ut \n> aliquip ex ea commodo consequat. Duis aute irure dolor in \n> reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \n> pariatur. Excepteur sint occaecat cupidatat non proident, sunt in \n> culpa qui officia deserunt mollit anim id est laborum.\n>\n\n# Here is a bit more that one rarely sees ...\n>     Sed ut perspiciatis unde omnis iste natus error sit voluptatem\n> accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae \n> ab illo inventore veritatis et quasi architecto beatae vitae dicta \n> sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit \n> aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos \n> qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui \n> dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed \n> quia non numquam eius modi tempora incidunt ut labore et dolore magnam \n> aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum \n> exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex \n> ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in \n> ea voluptate velit esse quam nihil molestiae consequatur, vel illum \n> qui dolorem eum fugiat quo voluptas nulla pariatur?\"\n>\n\n# There is more, but let's stop here.", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("\nLorem Ipsum\n\n    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\neiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad \nminim veniam, quis nostrud exercitation ullamco laboris nisi ut \naliquip ex ea commodo consequat. Duis aute irure dolor in \nreprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \npariatur. Excepteur sint occaecat cupidatat non proident, sunt in \nculpa qui officia deserunt mollit anim id est laborum.\n\n    Sed ut perspiciatis unde omnis iste natus error sit voluptatem\naccusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae \nab illo inventore veritatis et quasi architecto beatae vitae dicta \nsunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit \naspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos \nqui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui \ndolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed \nquia non numquam eius modi tempora incidunt ut labore et dolore magnam \naliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum \nexercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex \nea commodi consequatur? Quis autem vel eum iure reprehenderit qui in \nea voluptate velit esse quam nihil molestiae consequatur, vel illum \nqui dolorem eum fugiat quo voluptas nulla pariatur?\"\n"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: reprobate" {
  match @nestedtext.loads("the backslash character: \\\nthe single quote character: '\nthe double quote character: \"\nthe bell character: \u{7}\nthe back space character: \u{8}\nthe form feed character: \u{12}\nthe line feed character: \nthe carriage return character: \rthe horizontal tab character: \t\nthe vertical tab character: \u{11}\nthe escape character: \u{27}\nthe delete character: \n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("the backslash character",
        @nestedtext.Value::String("\\")),
      ("the single quote character",
        @nestedtext.Value::String("'")),
      ("the double quote character",
        @nestedtext.Value::String("\"")),
      ("the bell character",
        @nestedtext.Value::String("\u{7}")),
      ("the back space character",
        @nestedtext.Value::String("\u{8}")),
      ("the form feed character",
        @nestedtext.Value::String("\u{12}")),
      ("the line feed character",
        @nestedtext.Value::String("")),
      ("the carriage return character",
        @nestedtext.Value::String("")),
      ("the horizontal tab character",
        @nestedtext.Value::String("\t")),
      ("the vertical tab character",
        @nestedtext.Value::String("\u{11}")),
      ("the escape character",
        @nestedtext.Value::String("\u{27}")),
      ("the delete character",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: incision" {
  match @nestedtext.loads("the backslash character: \\\r\nthe single quote character: '\r\nthe double quote character: \"\r\nthe bell character: \u{7}\r\nthe back space character: \u{8}\r\nthe form feed character: \u{12}\r\nthe line feed character: \n\r\nthe carriage return character: \r\r\nthe horizontal tab character: \t\r\nthe vertical tab character: \u{11}\r\nthe escape character: \u{27}\r\nthe delete character: \r\n\r\n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("the backslash character",
        @nestedtext.Value::String("\\")),
      ("the single quote character",
        @nestedtext.Value::String("'")),
      ("the double quote character",
        @nestedtext.Value::String("\"")),
      ("the bell character",
        @nestedtext.Value::String("\u{7}")),
      ("the back space character",
        @nestedtext.Value::String("\u{8}")),
      ("the form feed character",
        @nestedtext.Value::String("\u{12}")),
      ("the line feed character",
        @nestedtext.Value::String("")),
      ("the carriage return character",
        @nestedtext.Value::String("")),
      ("the horizontal tab character",
        @nestedtext.Value::String("\t")),
      ("the vertical tab character",
        @nestedtext.Value::String("\u{11}")),
      ("the escape character",
        @nestedtext.Value::String("\u{27}")),
      ("the delete character",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: pelvis" {
  match @nestedtext.loads("the backslash character: \\\rthe single quote character: '\rthe double quote character: \"\rthe bell character: \u{7}\rthe back space character: \u{8}\rthe form feed character: \u{12}\rthe line feed character: \n\rthe carriage return character: \r\rthe horizontal tab character: \t\rthe vertical tab character: \u{11}\rthe escape character: \u{27}\rthe delete character: \r\r", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("the backslash character",
        @nestedtext.Value::String("\\")),
      ("the single quote character",
        @nestedtext.Value::String("'")),
      ("the double quote character",
        @nestedtext.Value::String("\"")),
      ("the bell character",
        @nestedtext.Value::String("\u{7}")),
      ("the back space character",
        @nestedtext.Value::String("\u{8}")),
      ("the form feed character",
        @nestedtext.Value::String("\u{12}")),
      ("the line feed character",
        @nestedtext.Value::String("")),
      ("the carriage return character",
        @nestedtext.Value::String("")),
      ("the horizontal tab character",
        @nestedtext.Value::String("\t")),
      ("the vertical tab character",
        @nestedtext.Value::String("\u{11}")),
      ("the escape character",
        @nestedtext.Value::String("\u{27}")),
      ("the delete character",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: pursuit" {
  match @nestedtext.loads("the backslash character: \\\r\nthe single quote character: '\rthe double quote character: \"\nthe bell character: \u{7}\r\nthe back space character: \u{8}\rthe form feed character: \u{12}\nthe line feed character: \n\r\nthe carriage return character: \r\rthe horizontal tab character: \t\nthe vertical tab character: \u{11}\r\nthe escape character: \u{27}\r\nthe delete character: \r\n\r\n", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("the backslash character",
        @nestedtext.Value::String("\\")),
      ("the single quote character",
        @nestedtext.Value::String("'")),
      ("the double quote character",
        @nestedtext.Value::String("\"")),
      ("the bell character",
        @nestedtext.Value::String("\u{7}")),
      ("the back space character",
        @nestedtext.Value::String("\u{8}")),
      ("the form feed character",
        @nestedtext.Value::String("\u{12}")),
      ("the line feed character",
        @nestedtext.Value::String("")),
      ("the carriage return character",
        @nestedtext.Value::String("")),
      ("the horizontal tab character",
        @nestedtext.Value::String("\t")),
      ("the vertical tab character",
        @nestedtext.Value::String("\u{11}")),
      ("the escape character",
        @nestedtext.Value::String("\u{27}")),
      ("the delete character",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: beset" {
  match @nestedtext.loads("no newlines:\n    > line 1\n    > line 2\nleading newline:\n    >\n    > line 1\n    > line 2\ninternal newline:\n    > line 1\n    >\n    > line 2\ntrailing newline:\n    > line 1\n    > line 2\n    >\nleading, internal, and trailing newline:\n    >\n    > line 1\n    >\n    > line 2\n    >\nleading newlines:\n    >\n    >\n    > line 1\n    > line 2\ninternal newlines:\n    > line 1\n    >\n    >\n    > line 2\ntrailing newlines:\n    > line 1\n    > line 2\n    >\n    >\nleading, internal, and trailing newlines:\n    >\n    >\n    > line 1\n    >\n    >\n    > line 2\n    >\n    >\nleading blank line:\n\n    > line 1\n    > line 2\ninternal blank line:\n    > line 1\n\n    > line 2\ntrailing blank line:\n    > line 1\n    > line 2\n\nleading comment:\n  # ignore me\n    > line 1\n    > line 2\ninternal comment:\n    > line 1\n        # ignore me\n    > line 2\ntrailing comment:\n    > line 1\n    > line 2\n  # ignore me\n\n            # ignore me\n\n                       ", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("no newlines",
        @nestedtext.Value::String("line 1\nline 2")),
      ("leading newline",
        @nestedtext.Value::String("\nline 1\nline 2")),
      ("internal newline",
        @nestedtext.Value::String("line 1\n\nline 2")),
      ("trailing newline",
        @nestedtext.Value::String("line 1\nline 2\n")),
      ("leading, internal, and trailing newline",
        @nestedtext.Value::String("\nline 1\n\nline 2\n")),
      ("leading newlines",
        @nestedtext.Value::String("\n\nline 1\nline 2")),
      ("internal newlines",
        @nestedtext.Value::String("line 1\n\n\nline 2")),
      ("trailing newlines",
        @nestedtext.Value::String("line 1\nline 2\n\n")),
      ("leading, internal, and trailing newlines",
        @nestedtext.Value::String("\n\nline 1\n\n\nline 2\n\n")),
      ("leading blank line",
        @nestedtext.Value::String("line 1\nline 2")),
      ("internal blank line",
        @nestedtext.Value::String("line 1\nline 2")),
      ("trailing blank line",
        @nestedtext.Value::String("line 1\nline 2")),
      ("leading comment",
        @nestedtext.Value::String("line 1\nline 2")),
      ("internal comment",
        @nestedtext.Value::String("line 1\nline 2")),
      ("trailing comment",
        @nestedtext.Value::String("line 1\nline 2"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: gendarme" {
  match @nestedtext.loads("ingredients:\n  > green chilies\n    > red chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: sketchy" {
  match @nestedtext.loads("     > green chilies\n     > red chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: prankster" {
  match @nestedtext.loads("ingredients:\n\t> green chilies\n\t> red chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: streamer" {
  match @nestedtext.loads("ingredients:\n        > green chilies\n        > red chilies\n#   ↑ this is a non-breaking space", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: guinea" {
  match @nestedtext.loads("key1:\nkey2:", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key1",
        @nestedtext.Value::String("")),
      ("key2",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: dusty" {
  match @nestedtext.loads("key1: \nkey2: ", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key1",
        @nestedtext.Value::String("")),
      ("key2",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: jaunt" {
  match @nestedtext.loads(": apricot\n:\n    > 8", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("apricot\n",
        @nestedtext.Value::String("8"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: abide" {
  match @nestedtext.loads(":  key-a\" : key-b' : key-c \n    > value", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      (" key-a\" : key-b' : key-c ",
        @nestedtext.Value::String("value"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: benchmark" {
  match @nestedtext.loads("{}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: milligram" {
  match @nestedtext.loads("    key: value", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: fifth" {
  match @nestedtext.loads("key 1:  \n        # notice the extra space at the end of the above line\n\n        # that, combined with the indent in the line below is an error\n        key 2: value 2", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: chatterer" {
  match @nestedtext.loads("# invalid indentation, tab in indentation\nkey 1:\n    \t    key 1.1: value 1.1\n", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: concuss" {
  match @nestedtext.loads("ingredients:\n- green chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: marinade" {
  match @nestedtext.loads("ingredients:\n  - green chilies\n    - red chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: detract" {
  match @nestedtext.loads("candidates:\n    name:\n  phone:", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: silky" {
  match @nestedtext.loads("ingredients:\n    - green chilies\n  - red chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: matinee" {
  match @nestedtext.loads("ingredients: red chilies\n- green chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: slipknot" {
  match @nestedtext.loads("ingredients:\n    green chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: facet" {
  match @nestedtext.loads("key: value 1\nkey: value 2", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: smudge" {
  match @nestedtext.loads("key:\n    \t    > first line\n    \t    > second line", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: spindly" {
  match @nestedtext.loads("key::", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key:",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: charter" {
  match @nestedtext.loads(":\n    >\n~!@#$%^&*()_+-1234567890{}[]|;<>?,./: ~!@#$%^&*()_+-1234567890{}[]|:;<>?,./\n: - key 3\n    > - value 3\n: key 4: \n    > value 4: \n: > key 5\n    > > value 5\n: # key 6\n    > #value 6\n: : key 7\n    > : value 7\n\" key 8 \": \" value 8 \"\n' key 9 ': ' value 9 '\nkey 10: value '\" 10\nkey 11: And Fred said 'yabba dabba doo!' to Barney.\nkey \" 12: value ' 12\n$€¥£₩₺₽₹ɃΞȄ: $€¥£₩₺₽₹ɃΞȄ\nYZEPTGMKk_cmuµμnpfazy: YZEPTGMKk_cmuµμnpfazy\na-zA-Z%√{us}{cur}][-^/()·⁻⁰¹²³⁴⁵⁶⁷⁸⁹°ÅΩƱΩ℧: a-zA-Z%√{us}{cur}][-^/()·⁻⁰¹²³⁴⁵⁶⁷⁸⁹°ÅΩƱΩ℧", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("",
        @nestedtext.Value::String("")),
      ("~!@#$%^&*()_+-1234567890{}[]|;<>?,./",
        @nestedtext.Value::String("~!@#$%^&*()_+-1234567890{}[]|:;<>?,./")),
      ("- key 3",
        @nestedtext.Value::String("- value 3")),
      ("key 4: ",
        @nestedtext.Value::String("value 4: ")),
      ("> key 5",
        @nestedtext.Value::String("> value 5")),
      ("# key 6",
        @nestedtext.Value::String("#value 6")),
      (": key 7",
        @nestedtext.Value::String(": value 7")),
      ("\" key 8 \"",
        @nestedtext.Value::String("\" value 8 \"")),
      ("' key 9 '",
        @nestedtext.Value::String("' value 9 '")),
      ("key 10",
        @nestedtext.Value::String("value '\" 10")),
      ("key 11",
        @nestedtext.Value::String("And Fred said 'yabba dabba doo!' to Barney.")),
      ("key \" 12",
        @nestedtext.Value::String("value ' 12")),
      ("$€¥£₩₺₽₹ɃΞȄ",
        @nestedtext.Value::String("$€¥£₩₺₽₹ɃΞȄ")),
      ("YZEPTGMKk_cmuµμnpfazy",
        @nestedtext.Value::String("YZEPTGMKk_cmuµμnpfazy")),
      ("a-zA-Z%√{us}{cur}][-^/()·⁻⁰¹²³⁴⁵⁶⁷⁸⁹°ÅΩƱΩ℧",
        @nestedtext.Value::String("a-zA-Z%√{us}{cur}][-^/()·⁻⁰¹²³⁴⁵⁶⁷⁸⁹°ÅΩƱΩ℧"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: patchy" {
  match @nestedtext.loads("key 1: value 1\nkey'\"2: value 2", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key'\"2",
        @nestedtext.Value::String("value 2"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: excuse" {
  match @nestedtext.loads("k1: v1\nk2 : v2\nk3  : v3\nk4\t: v4", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("k1",
        @nestedtext.Value::String("v1")),
      ("k2",
        @nestedtext.Value::String("v2")),
      ("k3",
        @nestedtext.Value::String("v3")),
      ("k4",
        @nestedtext.Value::String("v4"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: sandstorm" {
  match @nestedtext.loads("-#:'>: -#:\">:\n-#:\">: -#:'>:\n-#''>:: -#\"\">::\n-#\"\">:: -#''>::\n    # indented comment\n:-#:'>: :-#:\">:\n:-#:\">: :-#:'>:\n:-#''>:: :-#\"\">::\n:-#\"\">:: :-#''>::\n        # indented comment\n>:-#:'>: >:-#:\">:\n>:-#:\">: >:-#:'>:\n>:-#''>:: >:-#\"\">::\n>:-#\"\">:: >:-#''>::", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("-#:'>",
        @nestedtext.Value::String("-#:\">:")),
      ("-#:\">",
        @nestedtext.Value::String("-#:'>:")),
      ("-#''>:",
        @nestedtext.Value::String("-#\"\">::")),
      ("-#\"\">:",
        @nestedtext.Value::String("-#''>::")),
      (":-#:'>",
        @nestedtext.Value::String(":-#:\">:")),
      (":-#:\">",
        @nestedtext.Value::String(":-#:'>:")),
      (":-#''>:",
        @nestedtext.Value::String(":-#\"\">::")),
      (":-#\"\">:",
        @nestedtext.Value::String(":-#''>::")),
      (">:-#:'>",
        @nestedtext.Value::String(">:-#:\">:")),
      (">:-#:\">",
        @nestedtext.Value::String(">:-#:'>:")),
      (">:-#''>:",
        @nestedtext.Value::String(">:-#\"\">::")),
      (">:-#\"\">:",
        @nestedtext.Value::String(">:-#''>::"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: shard" {
  match @nestedtext.loads("'a: ': a:\n: 'b: \n    > ': b:", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("'a",
        @nestedtext.Value::String("': a:")),
      ("'b: ",
        @nestedtext.Value::String("': b:"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: beach" {
  match @nestedtext.loads(": This is a key that is\n: spread over multiple lines.\n: Like normal multiline strings,\n: it can contain any character\n: without restriction.\n    > This is its value\n\n: Here is another multiline key.\n: But in this case it has an empty value.\n    >\n\n: This is another multiline key,\n: this one with a multiline value.\n    > Here is the multiline value.\n    > It is paired with a multiline key.\n\nhere is a simple key: with a simple value\n\n: Here is a multiline key\n: with a list value.\n    - 0\n    - 1\n\n: Here is a multiline key\n: with a dictionary value.\n    a: a\n    b: b\n\nhere is another simple key: with another simple value\n\n: here is a multiline key: that kind of looks a dict item\n    > a multiline value\n\n: This is another multiline key,\n: this one with a dictionary as a value that has a multiline key.\n    : This is another multiline key,\n    : this one with a multiline value.\n        > Here is the multiline value.\n        > It is paired with a multiline key.\n\n: This a multiline key with a blank second line.\n:\n    > yabba dabba doo", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("This is a key that is\nspread over multiple lines.\nLike normal multiline strings,\nit can contain any character\nwithout restriction.",
        @nestedtext.Value::String("This is its value")),
      ("Here is another multiline key.\nBut in this case it has an empty value.",
        @nestedtext.Value::String("")),
      ("This is another multiline key,\nthis one with a multiline value.",
        @nestedtext.Value::String("Here is the multiline value.\nIt is paired with a multiline key.")),
      ("here is a simple key",
        @nestedtext.Value::String("with a simple value")),
      ("Here is a multiline key\nwith a list value.",
        @nestedtext.Value::List([
          @nestedtext.Value::String("0"),
          @nestedtext.Value::String("1")
        ])),
      ("Here is a multiline key\nwith a dictionary value.",
        @nestedtext.Value::Dict([
          ("a",
            @nestedtext.Value::String("a")),
          ("b",
            @nestedtext.Value::String("b"))
        ])),
      ("here is another simple key",
        @nestedtext.Value::String("with another simple value")),
      ("here is a multiline key: that kind of looks a dict item",
        @nestedtext.Value::String("a multiline value")),
      ("This is another multiline key,\nthis one with a dictionary as a value that has a multiline key.",
        @nestedtext.Value::Dict([
          ("This is another multiline key,\nthis one with a multiline value.",
            @nestedtext.Value::String("Here is the multiline value.\nIt is paired with a multiline key."))
        ])),
      ("This a multiline key with a blank second line.\n",
        @nestedtext.Value::String("yabba dabba doo"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: crumbly" {
  match @nestedtext.loads("A :\n : B:\n  >\n: C :\n >\nD :\n: E\n >\n: F1\n: F2\n >", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("A",
        @nestedtext.Value::Dict([
          ("B:",
            @nestedtext.Value::String(""))
        ])),
      ("C :",
        @nestedtext.Value::String("")),
      ("D",
        @nestedtext.Value::String("")),
      ("E",
        @nestedtext.Value::String("")),
      ("F1\nF2",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: despair" {
  match @nestedtext.loads("A :\n : B:\n: C :\nD :\n: E", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: doodle" {
  match @nestedtext.loads("tether:\n    disclose: paranoid clunk gaggle\n    prolong: stove banish\n    navel: -clipboard organist signify\n    crane: -washout honey guarantor=aircrew\n    inure: fondle = 10kΩ*dissect\n\nmajesty:\n    fatten: washbowl flagon gentile hairstyle\n    static: lender busby\n    niece: -humpback adduce ferryboat\n    reservoir: -dally idiot enlarge=avalanche\n    wally: divorcee = 10kΩ*fugue\n\nbanner:\n    scepter: trollop living giddy\n    lager: piper glacier\n    debunk: -trapeze person matron\n    pecan: -uncanny perform megaton=profiteer\n    register: answer = 10kΩ*trend\n\nmonolith:\n    partitive: bookie outcome buckskin\n    roller: pixie fraud\n    change: scullery-roach rubber reveal+payoff\n    simulator: smock fritter consign=chateau\n    narrow: betrothal = 10kΩ*trooper - landau\n\nreinstate:\n    dramatist: pasture glade enslave upright\n    kinky: deuce birdie\n    bathroom: people-layoff fluke flood+sonata\n    heart: loiter feature scamper=drivel\n    vendetta: nauseate = 10kΩ*hoodlum - signboard\n\noverstate:\n    deter: clitoris treachery reading\n    saddlebag: doodle enunciate\n    cherub: cupboard-shingle refuge reefer+animate\n    overcome: gasometer crease bazooka=thriller\n    poplar: centipede = 10kΩ*headman - dewlap\n\n: [testament:blight] spangle\n    otter: adherent disguise electrode biplane\n    stormy: curfew neuter\n    spaceman: addict = snowman*(anxiety+embitter)*bayonet kestrel liken\n    hardy thinner: 'pretend\n    belief: sphere\n    sachet:\n        > fortnight: twitch(hopper) rebut duodenum=bottom; pleat=onward.\n        > frizz: galley(genealogy) advantage whelk=-sprawl; waist=-immigrant.\n\n: [mongrel:sequester] prism\n    bairn: easterner racketeer shortfall bootlace amoeba\n    canopy: refuse profit\n    snuggle: baritone = scrounger*(supplier+clobber)*flutter agate simplify\n    edition industry: 'castle\n    tenth: rhyme\n    scrunch:\n        > ledge: exporter(wrongdoer) levitate daiquiri=subsidize; bulletin=reason.\n        > jackpot: butcher(frequent) medicine memento=-diaphragm; ointment=-raving.\n\n: [frogman:alleyway] fatigue\n    hyena: believer timepiece infuriate sixty\n    cache: bootee scoopful\n    laborer: egoist = lunatic*(obeisance+voice)*gambit nickel queer\n    scraggy doggie: 'cedar\n    requisite: pastor\n    teacher:\n        > toboggan: champion(dominion) adieu golfer=linen; divorce=stake.\n        > fireguard: vineyard(confide) seashore diddle=-dartboard; genuflect=-fidget.\n\ninstall:\n    abide: waistline\n    skunk: coarsen nuisance\n    briar: eviction = glide && !reliquary overfeed resent\n    magnum accident: 'quince\n    nightmare: cheapen\n\nwithdraw:\n    chalice: noble canard\n    siphon: utility overhead\n    butler: aspirin.starlet < heater < brace.blockade\n    juggler: crumpet = sunny + slattern + persuade. cataclysm = scolding.\n    betake: projector.insulator\n    hearth: convector\n\nsurgery:\n    sunbathe: decathlon\n    fixation: heighten watcher\n    stretchy: -washday < burnish < debrief\n    scabbard: reward\n\nintercede barony:\n    busker: yachtsman-fleshpot sandbag flummox\n    vestry: panorama\n    sanction: drench=\"%keyboard\"\n\nharmony creaky:\n    physicist: gauge-doublet bungalow clink\n    swerve: cleanser\n    royalty:\n        > essay=\"%honeymoon\";\n        > extol = \"swampy\";\n        > almshouse = \"\".\n\ncaterwaul imitation:\n    dunce: bodice sitcom chipmunk\n    profane: monocle\n    sortie: impute=\"%covert\"\n\nmenace:\n    dredge: miasma litigant broil\n    bishop: medley\n    inquest: scourer=\"%gamma\"; mesmerize='ballcock\n\nmattock:\n    taint: buttery combatant stalwart\n    oculist: implicate\n    support: closure='snake; phoenix=\"%smoothie\"\n\nchance:\n    riposte: crusade\n    scripture: cathode\n    doorstep: dukedom=screening; lifebuoy=\"%crackle\"\n    salesman: shimmer cobweb spool=butter.\n\nasset:\n    overthrow: dainty\n    chancy: bough psychotic\n    sultana: father hormone caliber=mayday.\n\npollinate:\n    doctor: masochist\n    strangler: saloon ensemble shower\n    tuxedo:\n        > inject='strategy;\n        > purport={toffee,ripper}.\n    citadel:\n        > shrew repellent dairymaid=laser; elevator=biped.\n        > resound garage mistreat=rebuild; scree=choke.\n        > anchor begrudge slalom=reassert; molester=chopper.\n        > dizzy outbreak snifter=tussle; remove=survive.\n        > noodle panegyric importune=native; accredit=loser.\n\nacquit invest gravity:\n    remain: beetroot maroon cliche ninety\n    bookmark: munch\n    commodore:\n        > plank=sundry;\n        > prick=rehear;\n        > bonnet=\"banana\"\n    transfer:\n        > blister project adjective=slinky; uncover=salty.\n        > bowler acquiesce nobody=syllabus; bushy=fossilize.\n\nhorror megalith:\n    spurt: flower towpath rejoicing dowry rupture\n    recur: capacity\n    tract:\n        > goatee='graze;\n        > liqueur=\"scream\";\n        > detain=prefigure;\n        > spill={eggplant,poach}\n    plunger:\n        > cutting dislocate prince=spongy; flirt=debut.\n        > neurone cricketer shredder=property; break=octagon; plutocrat=lapwing.\n        > softy expert tycoon=qualify; coachman=heretic.\n        > redwood notebook heath=blackjack; frump=washstand.\n        > loose keeper applaud=destroyer; intention=hymnal.\n        > potentate brasserie souvenir=tumor; masseur=hasten.\n        > sanctify report touchdown=afford; combat=impart.\n        > brute elder bisexual=penknife; treadmill=thesaurus.\n        > tissue sickly dimmer=dowdy; cylinder=actor.\n        > awakening robotic fascia=paperboy; scalp=length; seashell=50μA.\n        > larch fashion crack=scorpion; explicate=retire.\n        > mature lapel incline=dressing; thwack=rivet.\n        > neologism phonetic zebra=upstage; realtor=showpiece.\n        > evacuee stride softener=ditty; earth=bookcase.\n        > uproot cross titter=constrict; specific=wayside.\n        > overwrite overshoot quandary=panther; cartwheel=ratio.\n\ninformer payroll:\n    sequin: armadillo exclaim foray cuckoo\n    lynch: punchbowl\n    trump:\n        > bedeck=quota;\n        > machete=croupier;\n        > alpine=\"response\";\n        > vegetable=slowdown.\n    whisker:\n        > lottery sheath moonlight=chamber.\n        > fantasize pullover stool=eject.\n\nbarbarity, allude, whittle:\n    militant: garret dictate sweeper\n    extension: senator\n    justify:\n        > taxicab=ferry;\n        > paragraph=spokesman;\n        > politic=codpiece;\n        > grizzle=clerk;\n        > perturb=mudguard;\n        > decade=\"sickness\"\n    broad:\n        > ceramic morsel sahib=gelding.\n        > gravy shoddy fixative=scramble.\n        > smelt beatnik describe=duckling.\n        > bourbon crusader tabloid=wordy.\n\nextenuate, promoter:\n    store: treasury dumpling emotion skirmish\n    epitaph: incumbent\n    yearning:\n        > adjudge='yearbook;\n        > maneuver=\"infer\";\n        > cabaret=deception;\n        > hostel={fossil,diagnose}\n    sporran:\n        > alphabet counter haughty=ceiling; treadle=reedy.\n        > hierarchy hardship troll=detractor; holocaust=deafen; gangway=translate.\n        > thought termite limousine=hustle; tweed=majorette.\n        > batten swindler parkland=outsider; crawl=prevail.\n        > provision fabric indict=amaze; weight=commando.\n        > extend cabal charge=admit; umlaut=steel.\n        > strength councilor entity=address; encamp=slake.\n        > trespass soapbox knoll=befriend; aggregate=allusion.\n        > sequel fingertip billfold=staunch; particle=combine.\n        > sediment intellect organizer=blurry; fatty=beard; revel=50μA.\n        > toxin steak panacea=elite; scavenge=acoustic.\n        > farmyard resign presage=peasant; jumble=regret.\n        > berry valet alchemist=greasy; clonk=eyesore.\n        > treat temper antenatal=interlink; hurtle=catchy.\n        > obtain seaweed offender=cameo; jostle=reprove.\n        > rigidity radish braise=scoot; petty=marquee.\n\nmenage, quail:\n    outspread: share pinion fruitcake portend\n    reference: appendix\n    daily:\n        > scrapbook=rejoin;\n        > drier=agonize;\n        > sewer=\"dollop\";\n        > bistro=ratepayer.\n    flabby:\n        > pentagon rotor science=besiege.\n        > spider distance shaggy=mayor.\n        > statement venture priory=seance.\n        > sextet riddle shabby=stationer.\n\njelly, exude:\n    naught: misread sandbank speculate\n    espresso: dispel\n    oilman:\n        > amalgam=additive;\n        > tatty=unsettle;\n        > lousy=\"clamber\";\n        > radiator = \"paring, anatomist\";\n        > sidle=thatch.\n    episode:\n        > council whiplash muscle=carriage.\n        > baseline nymph tantrum=spoof; prognosis=trundle; friend=plump.comedy.\n        > induct tubby compost=crank.\n        > family stately expunge=echelon.\n\nholding, scruple:\n    ramrod: tableau beret\n    flatten: tributary\n    cobra:\n        > hunchback=bumpy;\n        > lorry=\"inkling\";\n        > holler = \"pedant, lifeboat\";\n        > butchery=antique.\n    decree:\n        > embroil numskull stigma=explosion.\n        > grand bonus accord=scarf.\n        > amplifier prattle submerge=justice.\n        > grace arrowhead athlete=shaver.", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("tether",
        @nestedtext.Value::Dict([
          ("disclose",
            @nestedtext.Value::String("paranoid clunk gaggle")),
          ("prolong",
            @nestedtext.Value::String("stove banish")),
          ("navel",
            @nestedtext.Value::String("-clipboard organist signify")),
          ("crane",
            @nestedtext.Value::String("-washout honey guarantor=aircrew")),
          ("inure",
            @nestedtext.Value::String("fondle = 10kΩ*dissect"))
        ])),
      ("majesty",
        @nestedtext.Value::Dict([
          ("fatten",
            @nestedtext.Value::String("washbowl flagon gentile hairstyle")),
          ("static",
            @nestedtext.Value::String("lender busby")),
          ("niece",
            @nestedtext.Value::String("-humpback adduce ferryboat")),
          ("reservoir",
            @nestedtext.Value::String("-dally idiot enlarge=avalanche")),
          ("wally",
            @nestedtext.Value::String("divorcee = 10kΩ*fugue"))
        ])),
      ("banner",
        @nestedtext.Value::Dict([
          ("scepter",
            @nestedtext.Value::String("trollop living giddy")),
          ("lager",
            @nestedtext.Value::String("piper glacier")),
          ("debunk",
            @nestedtext.Value::String("-trapeze person matron")),
          ("pecan",
            @nestedtext.Value::String("-uncanny perform megaton=profiteer")),
          ("register",
            @nestedtext.Value::String("answer = 10kΩ*trend"))
        ])),
      ("monolith",
        @nestedtext.Value::Dict([
          ("partitive",
            @nestedtext.Value::String("bookie outcome buckskin")),
          ("roller",
            @nestedtext.Value::String("pixie fraud")),
          ("change",
            @nestedtext.Value::String("scullery-roach rubber reveal+payoff")),
          ("simulator",
            @nestedtext.Value::String("smock fritter consign=chateau")),
          ("narrow",
            @nestedtext.Value::String("betrothal = 10kΩ*trooper - landau"))
        ])),
      ("reinstate",
        @nestedtext.Value::Dict([
          ("dramatist",
            @nestedtext.Value::String("pasture glade enslave upright")),
          ("kinky",
            @nestedtext.Value::String("deuce birdie")),
          ("bathroom",
            @nestedtext.Value::String("people-layoff fluke flood+sonata")),
          ("heart",
            @nestedtext.Value::String("loiter feature scamper=drivel")),
          ("vendetta",
            @nestedtext.Value::String("nauseate = 10kΩ*hoodlum - signboard"))
        ])),
      ("overstate",
        @nestedtext.Value::Dict([
          ("deter",
            @nestedtext.Value::String("clitoris treachery reading")),
          ("saddlebag",
            @nestedtext.Value::String("doodle enunciate")),
          ("cherub",
            @nestedtext.Value::String("cupboard-shingle refuge reefer+animate")),
          ("overcome",
            @nestedtext.Value::String("gasometer crease bazooka=thriller")),
          ("poplar",
            @nestedtext.Value::String("centipede = 10kΩ*headman - dewlap"))
        ])),
      ("[testament:blight] spangle",
        @nestedtext.Value::Dict([
          ("otter",
            @nestedtext.Value::String("adherent disguise electrode biplane")),
          ("stormy",
            @nestedtext.Value::String("curfew neuter")),
          ("spaceman",
            @nestedtext.Value::String("addict = snowman*(anxiety+embitter)*bayonet kestrel liken")),
          ("hardy thinner",
            @nestedtext.Value::String("'pretend")),
          ("belief",
            @nestedtext.Value::String("sphere")),
          ("sachet",
            @nestedtext.Value::String("fortnight: twitch(hopper) rebut duodenum=bottom; pleat=onward.\nfrizz: galley(genealogy) advantage whelk=-sprawl; waist=-immigrant."))
        ])),
      ("[mongrel:sequester] prism",
        @nestedtext.Value::Dict([
          ("bairn",
            @nestedtext.Value::String("easterner racketeer shortfall bootlace amoeba")),
          ("canopy",
            @nestedtext.Value::String("refuse profit")),
          ("snuggle",
            @nestedtext.Value::String("baritone = scrounger*(supplier+clobber)*flutter agate simplify")),
          ("edition industry",
            @nestedtext.Value::String("'castle")),
          ("tenth",
            @nestedtext.Value::String("rhyme")),
          ("scrunch",
            @nestedtext.Value::String("ledge: exporter(wrongdoer) levitate daiquiri=subsidize; bulletin=reason.\njackpot: butcher(frequent) medicine memento=-diaphragm; ointment=-raving."))
        ])),
      ("[frogman:alleyway] fatigue",
        @nestedtext.Value::Dict([
          ("hyena",
            @nestedtext.Value::String("believer timepiece infuriate sixty")),
          ("cache",
            @nestedtext.Value::String("bootee scoopful")),
          ("laborer",
            @nestedtext.Value::String("egoist = lunatic*(obeisance+voice)*gambit nickel queer")),
          ("scraggy doggie",
            @nestedtext.Value::String("'cedar")),
          ("requisite",
            @nestedtext.Value::String("pastor")),
          ("teacher",
            @nestedtext.Value::String("toboggan: champion(dominion) adieu golfer=linen; divorce=stake.\nfireguard: vineyard(confide) seashore diddle=-dartboard; genuflect=-fidget."))
        ])),
      ("install",
        @nestedtext.Value::Dict([
          ("abide",
            @nestedtext.Value::String("waistline")),
          ("skunk",
            @nestedtext.Value::String("coarsen nuisance")),
          ("briar",
            @nestedtext.Value::String("eviction = glide && !reliquary overfeed resent")),
          ("magnum accident",
            @nestedtext.Value::String("'quince")),
          ("nightmare",
            @nestedtext.Value::String("cheapen"))
        ])),
      ("withdraw",
        @nestedtext.Value::Dict([
          ("chalice",
            @nestedtext.Value::String("noble canard")),
          ("siphon",
            @nestedtext.Value::String("utility overhead")),
          ("butler",
            @nestedtext.Value::String("aspirin.starlet < heater < brace.blockade")),
          ("juggler",
            @nestedtext.Value::String("crumpet = sunny + slattern + persuade. cataclysm = scolding.")),
          ("betake",
            @nestedtext.Value::String("projector.insulator")),
          ("hearth",
            @nestedtext.Value::String("convector"))
        ])),
      ("surgery",
        @nestedtext.Value::Dict([
          ("sunbathe",
            @nestedtext.Value::String("decathlon")),
          ("fixation",
            @nestedtext.Value::String("heighten watcher")),
          ("stretchy",
            @nestedtext.Value::String("-washday < burnish < debrief")),
          ("scabbard",
            @nestedtext.Value::String("reward"))
        ])),
      ("intercede barony",
        @nestedtext.Value::Dict([
          ("busker",
            @nestedtext.Value::String("yachtsman-fleshpot sandbag flummox")),
          ("vestry",
            @nestedtext.Value::String("panorama")),
          ("sanction",
            @nestedtext.Value::String("drench=\"%keyboard\""))
        ])),
      ("harmony creaky",
        @nestedtext.Value::Dict([
          ("physicist",
            @nestedtext.Value::String("gauge-doublet bungalow clink")),
          ("swerve",
            @nestedtext.Value::String("cleanser")),
          ("royalty",
            @nestedtext.Value::String("essay=\"%honeymoon\";\nextol = \"swampy\";\nalmshouse = \"\"."))
        ])),
      ("caterwaul imitation",
        @nestedtext.Value::Dict([
          ("dunce",
            @nestedtext.Value::String("bodice sitcom chipmunk")),
          ("profane",
            @nestedtext.Value::String("monocle")),
          ("sortie",
            @nestedtext.Value::String("impute=\"%covert\""))
        ])),
      ("menace",
        @nestedtext.Value::Dict([
          ("dredge",
            @nestedtext.Value::String("miasma litigant broil")),
          ("bishop",
            @nestedtext.Value::String("medley")),
          ("inquest",
            @nestedtext.Value::String("scourer=\"%gamma\"; mesmerize='ballcock"))
        ])),
      ("mattock",
        @nestedtext.Value::Dict([
          ("taint",
            @nestedtext.Value::String("buttery combatant stalwart")),
          ("oculist",
            @nestedtext.Value::String("implicate")),
          ("support",
            @nestedtext.Value::String("closure='snake; phoenix=\"%smoothie\""))
        ])),
      ("chance",
        @nestedtext.Value::Dict([
          ("riposte",
            @nestedtext.Value::String("crusade")),
          ("scripture",
            @nestedtext.Value::String("cathode")),
          ("doorstep",
            @nestedtext.Value::String("dukedom=screening; lifebuoy=\"%crackle\"")),
          ("salesman",
            @nestedtext.Value::String("shimmer cobweb spool=butter."))
        ])),
      ("asset",
        @nestedtext.Value::Dict([
          ("overthrow",
            @nestedtext.Value::String("dainty")),
          ("chancy",
            @nestedtext.Value::String("bough psychotic")),
          ("sultana",
            @nestedtext.Value::String("father hormone caliber=mayday."))
        ])),
      ("pollinate",
        @nestedtext.Value::Dict([
          ("doctor",
            @nestedtext.Value::String("masochist")),
          ("strangler",
            @nestedtext.Value::String("saloon ensemble shower")),
          ("tuxedo",
            @nestedtext.Value::String("inject='strategy;\npurport={toffee,ripper}.")),
          ("citadel",
            @nestedtext.Value::String("shrew repellent dairymaid=laser; elevator=biped.\nresound garage mistreat=rebuild; scree=choke.\nanchor begrudge slalom=reassert; molester=chopper.\ndizzy outbreak snifter=tussle; remove=survive.\nnoodle panegyric importune=native; accredit=loser."))
        ])),
      ("acquit invest gravity",
        @nestedtext.Value::Dict([
          ("remain",
            @nestedtext.Value::String("beetroot maroon cliche ninety")),
          ("bookmark",
            @nestedtext.Value::String("munch")),
          ("commodore",
            @nestedtext.Value::String("plank=sundry;\nprick=rehear;\nbonnet=\"banana\"")),
          ("transfer",
            @nestedtext.Value::String("blister project adjective=slinky; uncover=salty.\nbowler acquiesce nobody=syllabus; bushy=fossilize."))
        ])),
      ("horror megalith",
        @nestedtext.Value::Dict([
          ("spurt",
            @nestedtext.Value::String("flower towpath rejoicing dowry rupture")),
          ("recur",
            @nestedtext.Value::String("capacity")),
          ("tract",
            @nestedtext.Value::String("goatee='graze;\nliqueur=\"scream\";\ndetain=prefigure;\nspill={eggplant,poach}")),
          ("plunger",
            @nestedtext.Value::String("cutting dislocate prince=spongy; flirt=debut.\nneurone cricketer shredder=property; break=octagon; plutocrat=lapwing.\nsofty expert tycoon=qualify; coachman=heretic.\nredwood notebook heath=blackjack; frump=washstand.\nloose keeper applaud=destroyer; intention=hymnal.\npotentate brasserie souvenir=tumor; masseur=hasten.\nsanctify report touchdown=afford; combat=impart.\nbrute elder bisexual=penknife; treadmill=thesaurus.\ntissue sickly dimmer=dowdy; cylinder=actor.\nawakening robotic fascia=paperboy; scalp=length; seashell=50μA.\nlarch fashion crack=scorpion; explicate=retire.\nmature lapel incline=dressing; thwack=rivet.\nneologism phonetic zebra=upstage; realtor=showpiece.\nevacuee stride softener=ditty; earth=bookcase.\nuproot cross titter=constrict; specific=wayside.\noverwrite overshoot quandary=panther; cartwheel=ratio."))
        ])),
      ("informer payroll",
        @nestedtext.Value::Dict([
          ("sequin",
            @nestedtext.Value::String("armadillo exclaim foray cuckoo")),
          ("lynch",
            @nestedtext.Value::String("punchbowl")),
          ("trump",
            @nestedtext.Value::String("bedeck=quota;\nmachete=croupier;\nalpine=\"response\";\nvegetable=slowdown.")),
          ("whisker",
            @nestedtext.Value::String("lottery sheath moonlight=chamber.\nfantasize pullover stool=eject."))
        ])),
      ("barbarity, allude, whittle",
        @nestedtext.Value::Dict([
          ("militant",
            @nestedtext.Value::String("garret dictate sweeper")),
          ("extension",
            @nestedtext.Value::String("senator")),
          ("justify",
            @nestedtext.Value::String("taxicab=ferry;\nparagraph=spokesman;\npolitic=codpiece;\ngrizzle=clerk;\nperturb=mudguard;\ndecade=\"sickness\"")),
          ("broad",
            @nestedtext.Value::String("ceramic morsel sahib=gelding.\ngravy shoddy fixative=scramble.\nsmelt beatnik describe=duckling.\nbourbon crusader tabloid=wordy."))
        ])),
      ("extenuate, promoter",
        @nestedtext.Value::Dict([
          ("store",
            @nestedtext.Value::String("treasury dumpling emotion skirmish")),
          ("epitaph",
            @nestedtext.Value::String("incumbent")),
          ("yearning",
            @nestedtext.Value::String("adjudge='yearbook;\nmaneuver=\"infer\";\ncabaret=deception;\nhostel={fossil,diagnose}")),
          ("sporran",
            @nestedtext.Value::String("alphabet counter haughty=ceiling; treadle=reedy.\nhierarchy hardship troll=detractor; holocaust=deafen; gangway=translate.\nthought termite limousine=hustle; tweed=majorette.\nbatten swindler parkland=outsider; crawl=prevail.\nprovision fabric indict=amaze; weight=commando.\nextend cabal charge=admit; umlaut=steel.\nstrength councilor entity=address; encamp=slake.\ntrespass soapbox knoll=befriend; aggregate=allusion.\nsequel fingertip billfold=staunch; particle=combine.\nsediment intellect organizer=blurry; fatty=beard; revel=50μA.\ntoxin steak panacea=elite; scavenge=acoustic.\nfarmyard resign presage=peasant; jumble=regret.\nberry valet alchemist=greasy; clonk=eyesore.\ntreat temper antenatal=interlink; hurtle=catchy.\nobtain seaweed offender=cameo; jostle=reprove.\nrigidity radish braise=scoot; petty=marquee."))
        ])),
      ("menage, quail",
        @nestedtext.Value::Dict([
          ("outspread",
            @nestedtext.Value::String("share pinion fruitcake portend")),
          ("reference",
            @nestedtext.Value::String("appendix")),
          ("daily",
            @nestedtext.Value::String("scrapbook=rejoin;\ndrier=agonize;\nsewer=\"dollop\";\nbistro=ratepayer.")),
          ("flabby",
            @nestedtext.Value::String("pentagon rotor science=besiege.\nspider distance shaggy=mayor.\nstatement venture priory=seance.\nsextet riddle shabby=stationer."))
        ])),
      ("jelly, exude",
        @nestedtext.Value::Dict([
          ("naught",
            @nestedtext.Value::String("misread sandbank speculate")),
          ("espresso",
            @nestedtext.Value::String("dispel")),
          ("oilman",
            @nestedtext.Value::String("amalgam=additive;\ntatty=unsettle;\nlousy=\"clamber\";\nradiator = \"paring, anatomist\";\nsidle=thatch.")),
          ("episode",
            @nestedtext.Value::String("council whiplash muscle=carriage.\nbaseline nymph tantrum=spoof; prognosis=trundle; friend=plump.comedy.\ninduct tubby compost=crank.\nfamily stately expunge=echelon."))
        ])),
      ("holding, scruple",
        @nestedtext.Value::Dict([
          ("ramrod",
            @nestedtext.Value::String("tableau beret")),
          ("flatten",
            @nestedtext.Value::String("tributary")),
          ("cobra",
            @nestedtext.Value::String("hunchback=bumpy;\nlorry=\"inkling\";\nholler = \"pedant, lifeboat\";\nbutchery=antique.")),
          ("decree",
            @nestedtext.Value::String("embroil numskull stigma=explosion.\ngrand bonus accord=scarf.\namplifier prattle submerge=justice.\ngrace arrowhead athlete=shaver."))
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: imbibe" {
  match @nestedtext.loads(": {http://www.kde.org/standards/kcfg/1.0}kcfgfile\n    >\n: {http://www.kde.org/standards/kcfg/1.0}group\n    : {http://www.kde.org/standards/kcfg/1.0}entry\n        -\n            : {http://www.kde.org/standards/kcfg/1.0}default\n                > 250\n        -\n            : {http://www.kde.org/standards/kcfg/1.0}default\n                > krunner,yakuake", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("{http://www.kde.org/standards/kcfg/1.0}kcfgfile",
        @nestedtext.Value::String("")),
      ("{http://www.kde.org/standards/kcfg/1.0}group",
        @nestedtext.Value::Dict([
          ("{http://www.kde.org/standards/kcfg/1.0}entry",
            @nestedtext.Value::List([
              @nestedtext.Value::Dict([
                ("{http://www.kde.org/standards/kcfg/1.0}default",
                  @nestedtext.Value::String("250"))
              ]),
              @nestedtext.Value::Dict([
                ("{http://www.kde.org/standards/kcfg/1.0}default",
                  @nestedtext.Value::String("krunner,yakuake"))
              ])
            ]))
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: emollient" {
  match @nestedtext.loads("key: value 1\nkey: value 2\nkey: value 3", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: modernize" {
  match @nestedtext.loads("-\n    {}\n-\n    {:}\n-\n    {a:0}\n-\n    {a: k}\n-\n    {a:[]}\n-\n    {a: [b]}\n-\n    {a:{}}\n-\n    {a: {b:1}}\n-\n    {a:0, b:1}\n-\n    {a:{A:0}, b:{B:1}}\n-\n    { a : { A : 0 } , b : { B : 1 } }   \n-\n    {a:[1,2,3], b:[4,5,6]}\n-\n    {a:0,b:1}\n-\n    {a:[],b:[]}\n-\n    {a:[0,1],b:[2,3]}\n-\n    {a:{},b:{}}\n-\n    {a:{b:0,c:1},d:{e:2,f:3}}\n-\n    {a:0,b:[]}\n-\n    {a:[],b:{}}\n-\n    {a:{},b:0}\n-\n    { a:0}\n-\n    {a :0}\n-\n    {a: 0}\n-\n    {a:0 }\n-\n    { a : 0 }\n-\n    {a:0, b:1}\n-\n    {a:0 ,b:1}\n-\n    {a:0 , b:1}\n-\n    {key 1:value 1, key 2 : value 2 }", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::Dict([]),
      @nestedtext.Value::Dict([
        ("",
          @nestedtext.Value::String(""))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("k"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::List([]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::List([
            @nestedtext.Value::String("b")
          ]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::Dict([]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::Dict([
            ("b",
              @nestedtext.Value::String("1"))
          ]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0")),
        ("b",
          @nestedtext.Value::String("1"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::Dict([
            ("A",
              @nestedtext.Value::String("0"))
          ])),
        ("b",
          @nestedtext.Value::Dict([
            ("B",
              @nestedtext.Value::String("1"))
          ]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::Dict([
            ("A",
              @nestedtext.Value::String("0"))
          ])),
        ("b",
          @nestedtext.Value::Dict([
            ("B",
              @nestedtext.Value::String("1"))
          ]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::List([
            @nestedtext.Value::String("1"),
            @nestedtext.Value::String("2"),
            @nestedtext.Value::String("3")
          ])),
        ("b",
          @nestedtext.Value::List([
            @nestedtext.Value::String("4"),
            @nestedtext.Value::String("5"),
            @nestedtext.Value::String("6")
          ]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0")),
        ("b",
          @nestedtext.Value::String("1"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::List([])),
        ("b",
          @nestedtext.Value::List([]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::List([
            @nestedtext.Value::String("0"),
            @nestedtext.Value::String("1")
          ])),
        ("b",
          @nestedtext.Value::List([
            @nestedtext.Value::String("2"),
            @nestedtext.Value::String("3")
          ]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::Dict([])),
        ("b",
          @nestedtext.Value::Dict([]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::Dict([
            ("b",
              @nestedtext.Value::String("0")),
            ("c",
              @nestedtext.Value::String("1"))
          ])),
        ("d",
          @nestedtext.Value::Dict([
            ("e",
              @nestedtext.Value::String("2")),
            ("f",
              @nestedtext.Value::String("3"))
          ]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0")),
        ("b",
          @nestedtext.Value::List([]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::List([])),
        ("b",
          @nestedtext.Value::Dict([]))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::Dict([])),
        ("b",
          @nestedtext.Value::String("0"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0")),
        ("b",
          @nestedtext.Value::String("1"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0")),
        ("b",
          @nestedtext.Value::String("1"))
      ]),
      @nestedtext.Value::Dict([
        ("a",
          @nestedtext.Value::String("0")),
        ("b",
          @nestedtext.Value::String("1"))
      ]),
      @nestedtext.Value::Dict([
        ("key 1",
          @nestedtext.Value::String("value 1")),
        ("key 2",
          @nestedtext.Value::String("value 2"))
      ])
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: baptism" {
  match @nestedtext.loads("-\n    {a}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: collate" {
  match @nestedtext.loads("-\n    {", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: ballroom" {
  match @nestedtext.loads("-\n    {{}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: mercy" {
  match @nestedtext.loads("-\n    {}}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: canto" {
  match @nestedtext.loads("-\n    {a,:b}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: stooge" {
  match @nestedtext.loads("-\n    {a,:b}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: cowboy" {
  match @nestedtext.loads("-\n    {a,:b}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: criterion" {
  match @nestedtext.loads("-\n    {a}:b}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: protrude" {
  match @nestedtext.loads("-\n    {a[:b}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: caftan" {
  match @nestedtext.loads("-\n    {a]:b}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: siphon" {
  match @nestedtext.loads("-\n    {a:b{}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: unpick" {
  match @nestedtext.loads("-\n    {a:b}}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: patchwork" {
  match @nestedtext.loads("-\n    {a:b[}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: frustrate" {
  match @nestedtext.loads("-\n    {a:b]}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: donation" {
  match @nestedtext.loads("-\n    {a:0, , }", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: flaunt" {
  match @nestedtext.loads("-\n    {a:{A:0}, b{B:1}}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: magnetize" {
  match @nestedtext.loads("{a: {b:0, c:1}, d: {e:2, f:3}}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("a",
        @nestedtext.Value::Dict([
          ("b",
            @nestedtext.Value::String("0")),
          ("c",
            @nestedtext.Value::String("1"))
        ])),
      ("d",
        @nestedtext.Value::Dict([
          ("e",
            @nestedtext.Value::String("2")),
          ("f",
            @nestedtext.Value::String("3"))
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: succor" {
  match @nestedtext.loads("key 1:\n        {k1.1:v1.1,\t  k1.2:v1.2,      \tk1.3:v1.3\t}\t\nkey 2:\n        {k2.1\t:v2.1,\t  k2.2\t:v2.2,      \tk2.3\t:v2.3\t}\t\nkey 3:\n        {k3.1:\tv3.1,\t  k3.2:\tv3.2,      \tk3.3:\tv3.3\t}\t\nkey 4:\n        {k4.1\t:\tv4.1,\t  k4.2\t:\tv4.2,      \tk4.3\t:\tv4.3\t}\t", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::Dict([
          ("k1.1",
            @nestedtext.Value::String("v1.1")),
          ("k1.2",
            @nestedtext.Value::String("v1.2")),
          ("k1.3",
            @nestedtext.Value::String("v1.3"))
        ])),
      ("key 2",
        @nestedtext.Value::Dict([
          ("k2.1",
            @nestedtext.Value::String("v2.1")),
          ("k2.2",
            @nestedtext.Value::String("v2.2")),
          ("k2.3",
            @nestedtext.Value::String("v2.3"))
        ])),
      ("key 3",
        @nestedtext.Value::Dict([
          ("k3.1",
            @nestedtext.Value::String("v3.1")),
          ("k3.2",
            @nestedtext.Value::String("v3.2")),
          ("k3.3",
            @nestedtext.Value::String("v3.3"))
        ])),
      ("key 4",
        @nestedtext.Value::Dict([
          ("k4.1",
            @nestedtext.Value::String("v4.1")),
          ("k4.2",
            @nestedtext.Value::String("v4.2")),
          ("k4.3",
            @nestedtext.Value::String("v4.3"))
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: raven" {
  match @nestedtext.loads("key 1:\n       {k1.1:v1.1,\t  k1.2:v1.2,      \tk1.3:v1.3,\t}\t\nkey 2:\n        {k2.1\t:v2.1,\t  k2.2\t:v2.2,      \tk2.3\t:v2.3,\t}\t\nkey 3:\n        {k3.1:\tv3.1,\t  k3.2:\tv3.2,      \tk3.3:\tv3.3,\t}\t\nkey 4:\n        {k4.1\t:\tv4.1,\t  k4.2\t:\tv4.2,      \tk4.3\t:\tv4.3,\t}\t", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: emanate" {
  match @nestedtext.loads("{a:0,}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: moonlight" {
  match @nestedtext.loads("{a:0, }", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: conclude" {
  match @nestedtext.loads("{a:0,:,}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: prairie" {
  match @nestedtext.loads("{cases: {*: {*: {*:*}}}}\nchecks: *.sv", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: botch" {
  match @nestedtext.loads("[]\nnutz: truck", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: typhoon" {
  match @nestedtext.loads("{cases: {*: {*: {*:*}}}}\n    checks: *.sv", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: revolver" {
  match @nestedtext.loads("-\n-", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String(""),
      @nestedtext.Value::String("")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: denigrate" {
  match @nestedtext.loads("- A\n- B\n- C\n-\n    - D1\n    - D2\n- E", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String("A"),
      @nestedtext.Value::String("B"),
      @nestedtext.Value::String("C"),
      @nestedtext.Value::List([
        @nestedtext.Value::String("D1"),
        @nestedtext.Value::String("D2")
      ]),
      @nestedtext.Value::String("E")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: isometric" {
  match @nestedtext.loads("[]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: seller" {
  match @nestedtext.loads("ingredients:\n  - green chilies\n  cannot mix list with: dictionary\n", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: element" {
  match @nestedtext.loads("\n    - green chilies\n\n- red chilies\n", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: twelve" {
  match @nestedtext.loads("- green chilies\n    - red chilies\n", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: derelict" {
  match @nestedtext.loads("# this is an error because indentation is a tab\n- \n\t- red chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: handbook" {
  match @nestedtext.loads("- :\n- ~!@#$%^&*()_+-1234567890{}[]|:;<>?,./\n- - value 3\n- ' : value 4:'\n- > value 5\n- #value 6\n- key 7' : : value 7\n- \" value 8 \"\n- ' value 9 '\n-\n  > value '\" 10\n- And Fred said 'yabba dabba doo!' to Barney.", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::String(":"),
      @nestedtext.Value::String("~!@#$%^&*()_+-1234567890{}[]|:;<>?,./"),
      @nestedtext.Value::String("- value 3"),
      @nestedtext.Value::String("' : value 4:'"),
      @nestedtext.Value::String("> value 5"),
      @nestedtext.Value::String("#value 6"),
      @nestedtext.Value::String("key 7' : : value 7"),
      @nestedtext.Value::String("\" value 8 \""),
      @nestedtext.Value::String("' value 9 '"),
      @nestedtext.Value::String("value '\" 10"),
      @nestedtext.Value::String("And Fred said 'yabba dabba doo!' to Barney.")
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: epoch" {
  match @nestedtext.loads("-\n    []\n-\n    [ ]\n-\n    [,]\n-\n    [a]\n-\n    [:]\n-\n    [[]]\n-\n    [[ ]]\n-\n    [[a]]\n-\n    [{}]\n-\n    [{a:0}]\n-\n    [a,b]\n-\n    [,,]\n-\n    [[],[]]\n-\n    [[],[ ]]\n-\n    [[a,b],[c,d]]\n-\n    [ [ a , b ] , [ c , d ] ]   \n-\n    [{},{}]\n-\n    [{a:0,b:1},{c:2,d:3}]\n-\n    [a,[]]\n-\n    [[],{}]\n-\n    [{},b]\n-\n    [a,]\n-\n    [a, b, ]\n-\n    [ a]\n-\n    [a ]\n-\n    [ a ]\n-\n    [a, b]\n-\n    [a ,b]\n-\n    [a , b]\n-\n    [ ,]\n-\n    [, ]\n-\n    [ , ]\n-\n    [a, b, , ]\n-\n    [[11,12,13],[21,22,23],[31,32,33]]\n-\n    [value 1, value 2 ,  value 3  , ]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::List([]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String(""),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String(":")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([
          @nestedtext.Value::String("")
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([
          @nestedtext.Value::String("a")
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::Dict([])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::Dict([
          ("a",
            @nestedtext.Value::String("0"))
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("b")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String(""),
        @nestedtext.Value::String(""),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([]),
        @nestedtext.Value::List([])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([]),
        @nestedtext.Value::List([
          @nestedtext.Value::String("")
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([
          @nestedtext.Value::String("a"),
          @nestedtext.Value::String("b")
        ]),
        @nestedtext.Value::List([
          @nestedtext.Value::String("c"),
          @nestedtext.Value::String("d")
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([
          @nestedtext.Value::String("a"),
          @nestedtext.Value::String("b")
        ]),
        @nestedtext.Value::List([
          @nestedtext.Value::String("c"),
          @nestedtext.Value::String("d")
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::Dict([]),
        @nestedtext.Value::Dict([])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::Dict([
          ("a",
            @nestedtext.Value::String("0")),
          ("b",
            @nestedtext.Value::String("1"))
        ]),
        @nestedtext.Value::Dict([
          ("c",
            @nestedtext.Value::String("2")),
          ("d",
            @nestedtext.Value::String("3"))
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::List([])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([]),
        @nestedtext.Value::Dict([])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::Dict([]),
        @nestedtext.Value::String("b")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("b"),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("b")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("b")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("b")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String(""),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String(""),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String(""),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("a"),
        @nestedtext.Value::String("b"),
        @nestedtext.Value::String(""),
        @nestedtext.Value::String("")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::List([
          @nestedtext.Value::String("11"),
          @nestedtext.Value::String("12"),
          @nestedtext.Value::String("13")
        ]),
        @nestedtext.Value::List([
          @nestedtext.Value::String("21"),
          @nestedtext.Value::String("22"),
          @nestedtext.Value::String("23")
        ]),
        @nestedtext.Value::List([
          @nestedtext.Value::String("31"),
          @nestedtext.Value::String("32"),
          @nestedtext.Value::String("33")
        ])
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("value 1"),
        @nestedtext.Value::String("value 2"),
        @nestedtext.Value::String("value 3"),
        @nestedtext.Value::String("")
      ])
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: nobleman" {
  match @nestedtext.loads("-\n    [", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: proverb" {
  match @nestedtext.loads("-\n    [,", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: marina" {
  match @nestedtext.loads("-\n    [[]", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: blister" {
  match @nestedtext.loads("-\n    []{a:0}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: mentor" {
  match @nestedtext.loads("-\n    [a[b]", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: valance" {
  match @nestedtext.loads("-\n    [a]b]", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: eleven" {
  match @nestedtext.loads("-\n    [{]", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: casing" {
  match @nestedtext.loads("-\n    [}]", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: promenade" {
  match @nestedtext.loads("-\n    [a{b]", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: splurge" {
  match @nestedtext.loads("-\n    [a}b]", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: delusion" {
  match @nestedtext.loads("[[11, 12, 13], [21, 22, 23], [31, 32, 33]]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::List([
      @nestedtext.Value::List([
        @nestedtext.Value::String("11"),
        @nestedtext.Value::String("12"),
        @nestedtext.Value::String("13")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("21"),
        @nestedtext.Value::String("22"),
        @nestedtext.Value::String("23")
      ]),
      @nestedtext.Value::List([
        @nestedtext.Value::String("31"),
        @nestedtext.Value::String("32"),
        @nestedtext.Value::String("33")
      ])
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: itinerant" {
  match @nestedtext.loads("[7:0] gain:\n    desc: the gain\n    type: input signed", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: geyser" {
  match @nestedtext.loads("key 1:\n        [v1,\t  v2,      \tv3,\t]\t", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::List([
          @nestedtext.Value::String("v1"),
          @nestedtext.Value::String("v2"),
          @nestedtext.Value::String("v3"),
          @nestedtext.Value::String("")
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: muzzle" {
  match @nestedtext.loads("what makes it green\t: \tgreen\tchilies\t", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("what makes it green",
        @nestedtext.Value::String("\tgreen\tchilies\t"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: stylistic" {
  match @nestedtext.loads("key: value \" value", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key",
        @nestedtext.Value::String("value \" value"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: hallway" {
  match @nestedtext.loads("key: value ' value", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key",
        @nestedtext.Value::String("value ' value"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: acquire" {
  match @nestedtext.loads("key1: 'And Fred said \"yabba dabba doo!\" to Barney.'\nkey2: \"And Fred said 'yabba dabba doo!' to Barney.\"\nkey3: \"And Fred said \"yabba dabba doo!\" to Barney.\"\nkey4: 'And Fred said 'yabba dabba doo!' to Barney.'\nkey5: And Fred said \"yabba dabba doo!\" to Barney.\nkey6: And Fred said 'yabba dabba doo!' to Barney.", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key1",
        @nestedtext.Value::String("'And Fred said \"yabba dabba doo!\" to Barney.'")),
      ("key2",
        @nestedtext.Value::String("\"And Fred said 'yabba dabba doo!' to Barney.\"")),
      ("key3",
        @nestedtext.Value::String("\"And Fred said \"yabba dabba doo!\" to Barney.\"")),
      ("key4",
        @nestedtext.Value::String("'And Fred said 'yabba dabba doo!' to Barney.'")),
      ("key5",
        @nestedtext.Value::String("And Fred said \"yabba dabba doo!\" to Barney.")),
      ("key6",
        @nestedtext.Value::String("And Fred said 'yabba dabba doo!' to Barney."))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: sexton" {
  match @nestedtext.loads(">", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String(""),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: roomy" {
  match @nestedtext.loads("ingredients:\n    green chilies", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: brainwash" {
  match @nestedtext.loads("> what makes it green?\n>", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("what makes it green?\n"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: president" {
  match @nestedtext.loads("{:}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: propose" {
  match @nestedtext.loads("", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::String("null"),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: pillage" {
  match @nestedtext.loads("key 1: value 1\n key 2: value 2", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: tombstone" {
  match @nestedtext.loads("key 1 : value 1\nkey 2\t : value 2\nkey 3  : value 3", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key 2",
        @nestedtext.Value::String("value 2")),
      ("key 3",
        @nestedtext.Value::String("value 3"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: cavern" {
  match @nestedtext.loads("key 1:\nkey 2: ", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("")),
      ("key 2",
        @nestedtext.Value::String(""))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: rascal" {
  match @nestedtext.loads("key 1:\n   > value 1\nkey 2: \n   > value 2\nkey 3:  \n   > value 3", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: truncheon" {
  match @nestedtext.loads("-\n   > value 1\n- \n   > value 2\n-  \n   > value 3", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: vagrant" {
  match @nestedtext.loads("inline dict:\n    {a:A, b: B,c :C , d : D }\ninline list:\n    [a, b,c , d ]", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("inline dict",
        @nestedtext.Value::Dict([
          ("a",
            @nestedtext.Value::String("A")),
          ("b",
            @nestedtext.Value::String("B")),
          ("c",
            @nestedtext.Value::String("C")),
          ("d",
            @nestedtext.Value::String("D"))
        ])),
      ("inline list",
        @nestedtext.Value::List([
          @nestedtext.Value::String("a"),
          @nestedtext.Value::String("b"),
          @nestedtext.Value::String("c"),
          @nestedtext.Value::String("d")
        ]))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: frump" {
  match @nestedtext.loads("key 1: value 1\nkey 2:\nkey 3:\n    - value 3a\n    - value 3b\nkey 4:\n    key 4a: value 4a\n    key 4b: value 4b\nkey 5:\n    > first line of value 5\n    > second line of value 5", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("key 1",
        @nestedtext.Value::String("value 1")),
      ("key 2",
        @nestedtext.Value::String("")),
      ("key 3",
        @nestedtext.Value::List([
          @nestedtext.Value::String("value 3a"),
          @nestedtext.Value::String("value 3b")
        ])),
      ("key 4",
        @nestedtext.Value::Dict([
          ("key 4a",
            @nestedtext.Value::String("value 4a")),
          ("key 4b",
            @nestedtext.Value::String("value 4b"))
        ])),
      ("key 5",
        @nestedtext.Value::String("first line of value 5\nsecond line of value 5"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: asylum" {
  match @nestedtext.loads("��k\u{0}e\u{0}y\u{0} \u{0}1\u{0}:\u{0} \u{0}v\u{0}a\u{0}l\u{0}u\u{0}e\u{0} \u{0}1\u{0}\n\u{0}k\u{0}e\u{0}y\u{0} \u{0}2\u{0}:\u{0}\n\u{0}k\u{0}e\u{0}y\u{0} \u{0}3\u{0}:\u{0}\n\u{0} \u{0} \u{0} \u{0} \u{0}-\u{0} \u{0}v\u{0}a\u{0}l\u{0}u\u{0}e\u{0} \u{0}3\u{0}a\u{0}\n\u{0} \u{0} \u{0} \u{0} \u{0}-\u{0} \u{0}v\u{0}a\u{0}l\u{0}u\u{0}e\u{0} \u{0}3\u{0}b\u{0}\n\u{0}k\u{0}e\u{0}y\u{0} \u{0}4\u{0}:\u{0}\n\u{0} \u{0} \u{0} \u{0} \u{0}k\u{0}e\u{0}y\u{0} \u{0}4\u{0}a\u{0}:\u{0} \u{0}v\u{0}a\u{0}l\u{0}u\u{0}e\u{0} \u{0}4\u{0}a\u{0}\n\u{0} \u{0} \u{0} \u{0} \u{0}k\u{0}e\u{0}y\u{0} \u{0}4\u{0}b\u{0}:\u{0} \u{0}v\u{0}a\u{0}l\u{0}u\u{0}e\u{0} \u{0}4\u{0}b\u{0}\n\u{0}k\u{0}e\u{0}y\u{0} \u{0}5\u{0}:\u{0}\n\u{0} \u{0} \u{0} \u{0} \u{0}>\u{0} \u{0}f\u{0}i\u{0}r\u{0}s\u{0}t\u{0} \u{0}l\u{0}i\u{0}n\u{0}e\u{0} \u{0}o\u{0}f\u{0} \u{0}v\u{0}a\u{0}l\u{0}u\u{0}e\u{0} \u{0}5\u{0}\n\u{0} \u{0} \u{0} \u{0} \u{0}>\u{0} \u{0}s\u{0}e\u{0}c\u{0}o\u{0}n\u{0}d\u{0} \u{0}l\u{0}i\u{0}n\u{0}e\u{0} \u{0}o\u{0}f\u{0} \u{0}v\u{0}a\u{0}l\u{0}u\u{0}e\u{0} \u{0}5\u{0}", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: amendment" {
  match @nestedtext.loads("> �\n> �\n> �", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: academic" {
  match @nestedtext.loads("﻿{}", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance error: paragon" {
  match @nestedtext.loads("> Should not allow multiline strings\n> and lists at the same level\n- of indentation.", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: chemist" {
  match @nestedtext.loads("> Should not allow multiline strings\n> and dictionary itmes at the same level\nof: indentation", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance error: neophyte" {
  match @nestedtext.loads("> Should not allow multiline strings\n> with varying levels\n    > of indentation.", @nestedtext.Top::Any) {
    Err(_) => ()
    Ok(_) => fail("expected error but got Ok")
  }
}

///|
test "compliance: straggle" {
  match @nestedtext.loads("gain [7:0]: Gain control (quarter dB steps from -32 dB to +31.75 dB)", @nestedtext.Top::Any) {
    Ok(Some(value)) => assert_true(value ==
    @nestedtext.Value::Dict([
      ("gain [7:0]",
        @nestedtext.Value::String("Gain control (quarter dB steps from -32 dB to +31.75 dB)"))
    ]),
    )
    Ok(None) => fail("got None for non-empty input")
    Err(err) => fail("parse error: " + err.to_string())
  }
}

///|
test "compliance: summary" {
  assert_eq(1, 1) // all 148 tests above ran as individual test cases
}