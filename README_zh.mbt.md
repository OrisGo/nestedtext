# OrisGo/nestedtext

[English](README.mbt.md)

NestedText 序列化格式的 MoonBit 实现，包含解析器、生成器与类型化反序列化适配器。

> **注意**：本项目是 Rust [nested-text](https://github.com/hansstimer/nested-text) crate 的 MoonBit 移植版，沿用其 Apache-2.0 或 MIT 双许可。

_NestedText_ 是一种注重简洁易用的人类可读数据格式。详见 [nestedtext.org](https://nestedtext.org/) 规范。

## 快速开始

### 作为库使用

```bash
moon add OrisGo/nestedtext
```

```mbt check
///|
test "quick start" {
  match @nestedtext.loads("name: Alice\nage: 30", @nestedtext.Top::Any) {
    Ok(Some(v)) =>
      println(@nestedtext.dumps(v, @nestedtext.DumpOptions::default()))
    Ok(None) => println("(empty)")
    Err(e) => println("error: \{e.to_string()}")
  }
}
```

库接受 `String` 输入。你需要先读取 `.nt` 文件，再将内容传给 `loads`：

```mbt nocheck
let content = @fs.read_file_to_string("config.nt") catch {
  IOError(msg) => { println(msg); return }
}
match @nestedtext.loads(content, @nestedtext.Top::Any) {
  Ok(Some(v)) => { /* 使用 v */ }
  Err(e) => println(e.to_string())
}
```

> `moonbitlang/core` 目前尚未包含稳定的 `@fs` 模块。参见[文件 I/O](#文件-io)章节了解可选方案。

### 作为 CLI 工具

```bash
moon run cmd/main -- examples/config.nt
```

```
=== examples/config.nt ===
PASS | 8 lines | 5ms | -> examples/config.nt.out
```

通过环境变量限制顶层类型：

```bash
$env:NESTEDTEXT_TOP = "list"; moon run cmd/main -- examples/data.nt
```

## 文件 I/O

`@nestedtext` 库本身仅依赖 `moonbitlang/core`（稳定版），**不**引入文件 I/O 包，让你自主控制如何读取文件。

读取 `.nt` 文件的可选方案：

| 方案 | 状态 | 建议 |
|------|------|------|
| `moonbitlang/x/fs` | 实验性（`moonbitlang/x` v0.4.x） | 现在可用 — 在 native 目标上工作 |
| `moonbitlang/core/fs` | 计划中（beta-preview，预计 2026 年 8 月） | 等待稳定版发布 |
| 外部语言（Python 等） | 始终可用 | 通过 subprocess 或 FFI 桥接 |

如果使用 `moonbitlang/x/fs`，请将其加入**应用层** `moon.pkg`（而非库依赖）：

```mbt nocheck
import {
  "OrisGo/nestedtext" @nestedtext,
  "moonbitlang/x/fs" @fs,
}
```

然后读取并解析：

```mbt nocheck
let content = @fs.read_file_to_string("data.nt") catch {
  IOError(msg) => { println(msg); return }
}
match @nestedtext.loads(content, @nestedtext.Top::Any) {
  Ok(Some(v)) => println(@nestedtext.dumps(v, @nestedtext.DumpOptions::default()))
  Err(e) => println(e.to_string())
}
```

项目自带的 CLI（`cmd/main`）使用 `moonbitlang/x/fs` 作为参考实现。待 `@fs` 进入 core 后，CLI 将切换至稳定版，届时库可能增加便捷的 `read_file` 方法。

## 解析

使用 `loads` 将 NestedText 文档解析为 `Value` 树。传入 `Top` 约束可校验顶层形状。

```mbt check
///|
test "parse dictionary" {
  let input = "name: Alice\nage: 30"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(@nestedtext.Value::Dict(pairs))) => {
      @debug.assert_eq(pairs[0], ("name", @nestedtext.Value::String("Alice")))
      @debug.assert_eq(pairs[1], ("age", @nestedtext.Value::String("30")))
    }
    _ => fail("unexpected result")
  }
}

///|
test "parse nested list" {
  let input = "fruits:\n  - apple\n  - banana"
  match @nestedtext.loads(input, @nestedtext.Top::Dict) {
    Ok(Some(@nestedtext.Value::Dict(pairs))) => {
      @debug.assert_eq(pairs[0].0, "fruits")
      let expected = @nestedtext.Value::List([
        @nestedtext.Value::String("apple"),
        @nestedtext.Value::String("banana"),
      ])
      @debug.assert_eq(pairs[0].1, expected)
    }
    _ => fail("unexpected result")
  }
}
```

`Value` 有三个变体：

| 变体 | 含义 |
|------|------|
| `String(String)` | 标量字符串值 |
| `List(Array[Value])` | 有序列表 |
| `Dict(Array[(String, Value)])` | 按插入顺序排列的键值对 |

## 序列化

使用 `dumps` 将 `Value` 序列化为 NestedText 格式。

```mbt check
///|
test "serialize to nestedtext" {
  let value = @nestedtext.Value::Dict([
    ("name", @nestedtext.Value::String("Alice")),
    ("age", @nestedtext.Value::String("30")),
  ])
  let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
  @debug.assert_eq(output, "name: Alice\nage: 30\n")
}

///|
test "serialize with sorted keys" {
  let value = @nestedtext.Value::Dict([
    ("z", @nestedtext.Value::String("last")),
    ("a", @nestedtext.Value::String("first")),
  ])
  let opts = @nestedtext.DumpOptions::{ indent: 4, sort_keys: true }
  @debug.assert_eq(@nestedtext.dumps(value, opts), "a: first\nz: last\n")
}

///|
test "roundtrip" {
  let input = "name: Alice\nage: 30"
  match @nestedtext.loads(input, @nestedtext.Top::Any) {
    Ok(Some(value)) => {
      let output = @nestedtext.dumps(value, @nestedtext.DumpOptions::default())
      match @nestedtext.loads(output, @nestedtext.Top::Any) {
        Ok(Some(rv)) => @debug.assert_eq(value, rv)
        _ => fail("roundtrip parse failed")
      }
    }
    _ => fail("initial parse failed")
  }
}
```

## 类型化反序列化

`Deserializer` 在 `Value` 之上提供类型化提取——设计理念与 Rust 的 [serde](https://serde.rs/) 类似。使用 `deserialize_str` 可一步完成解析与反序列化，也可对已解析的 `Value` 调用 `deserialize_value`。

### 与 Rust serde 的对比

与 serde 不同，本库**不**使用 trait 或 derive 宏，而是通过**高阶函数**驱动反序列化：你提供一个闭包 `fn(Deserializer) -> Result[T, DeserializeError]`，在闭包中调用类型化提取方法来构造目标类型。

| 方面 | Rust serde | OrisGo/nestedtext |
|------|-----------|-------------------|
| 机制 | `Deserialize` trait + `#[derive(Deserialize)]` | 回调闭包 `fn(Deserializer) -> Result[T, _]` |
| 结构体反序列化 | derive 自动生成 | 手动通过 `get_field` + `expect_*` 组合 |
| Visitor 模式 | `Visitor` trait，含 `visit_*` 方法 | 直接调用 `Deserializer` 上的方法 |
| 错误传播 | `serde::de::Error` trait | `Result[T, DeserializeError]` 配合 `try` 链式处理 |
| 输入格式 | 通用数据模型 | 仅 NestedText AST（`Value` enum） |
| 所有值均为字符串 | 不适用（取决于格式） | 是 — `expect_int()` 等方法均从 `Value::String` 解析 |

### 用法

```mbt check
///|
test "deserialize typed struct" {
  fn person(
    d : @nestedtext.Deserializer,
  ) -> Result[(String, Int), @nestedtext.DeserializeError] {
    match d.get_field("name") {
      Ok(nd) =>
        match nd.expect_string() {
          Ok(name) =>
            match d.get_field("age") {
              Ok(ad) =>
                match ad.expect_int() {
                  Ok(age) => Ok((name, age))
                  Err(e) => Err(e)
                }
              Err(e) => Err(e)
            }
          Err(e) => Err(e)
        }
      Err(e) => Err(e)
    }
  }
  let input = "name: Alice\nage: 30"
  match @nestedtext.deserialize_str(input, @nestedtext.Top::Any, person) {
    Ok((name, age)) => {
      @debug.assert_eq(name, "Alice")
      @debug.assert_eq(age, 30)
    }
    Err(e) => fail(e.to_string())
  }
}

///|
test "deserialize list of ints" {
  let d = @nestedtext.Deserializer::new(
    @nestedtext.Value::List([
      @nestedtext.Value::String("1"),
      @nestedtext.Value::String("2"),
      @nestedtext.Value::String("3"),
    ]),
  )
  match @nestedtext.deserialize_list(d, fn(d2) { d2.expect_int() }) {
    Ok(ints) => @debug.assert_eq(ints, [1, 2, 3])
    Err(_) => fail("unexpected error")
  }
}

///|
test "deserialize optional field" {
  let d = @nestedtext.Deserializer::new(@nestedtext.Value::String(""))
  match d.expect_optional(fn(d2) { d2.expect_int() }) {
    Ok(None) => ()
    _ => fail("expected None")
  }
}
```

`Deserializer` 提取方法：

| 方法 | 目标类型 | 说明 |
|------|---------|------|
| `expect_string()` | `String` | 直接提取 |
| `expect_int()` | `Int` | 解析十进制字符串 |
| `expect_int64()` | `Int64` | 解析十进制字符串 |
| `expect_double()` | `Double` | 解析十进制字符串 |
| `expect_bool()` | `Bool` | 接受 `true`/`True`/`TRUE`/`yes`/`Yes`/`YES`（以及等价的 false/no 形式）|
| `expect_list()` | `Array[Value]` | 原始列表项 |
| `expect_dict()` | `Array[(String, Value)]` | 原始字典键值对 |
| `get_field(key)` | `Deserializer` | 查找单个字段 |
| `expect_optional(f)` | `T?` | `""` → `None`，否则 → `Some(f(d))` |
| `has_field(key)` | `Bool` | 检查键是否存在 |
| `field_names()` | `Array[String]` | 字典中的所有键 |

## 错误处理

解析错误携带位置元数据（行号、列号、源码行）。

```mbt check
///|
test "error location" {
  match @nestedtext.loads("key: value", @nestedtext.Top::Any) {
    Ok(value) =>
      match
        @nestedtext.deserialize_value(value.unwrap(), fn(d) { d.expect_int() }) {
        Err(e) => @debug.assert_eq(e.message, "expected string, got dictionary")
        Ok(_) => fail("expected error")
      }
    Err(e) => fail(e.to_string())
  }
}

///|
test "parse error with location" {
  match @nestedtext.loads("  key: value", @nestedtext.Top::Any) {
    Err(err) => {
      @debug.assert_eq(err.message, "top-level content must start in column 1.")
      assert_true(err.lineno == Some(1))
    }
    Ok(_) => fail("expected error")
  }
}
```

## 重要：编码

NestedText 文档必须是合法的 UTF-8。`loads` 接受 `String` 类型，在 MoonBit 中始终为 UTF-8 编码。包含非法 UTF-8 字节序列的二进制数据将被替换为替换字符（`U+FFFD`），`loads` 会返回一个指示首个替换字符位置的错误。

**已知问题**：`moon fmt` 在 `compliance_test.mbt` 上可能**超时**。该文件约 3200 行，包含深度嵌套的字面量表达式。

## 开发进度

- [x] 最小化 Value API 与快速失败入口
- [x] 词法分析器（行分类、BOM 剥离、换行规范化、缩进校验）
- [x] 解析器（基础块级字典、列表、多行字符串、多行键、内联值）
- [x] 生成器（dumps、DumpOptions、渲染辅助函数）
- [x] 官方合规测试集：截至 2026-07-06，173 项测试全部通过
- [x] 错误信息措辞及行列元数据与官方规范对齐
- [x] 反序列化适配器（`Deserializer`、`deserialize_str`、`deserialize_value`、`deserialize_list`）
- [x] CLI 校验器（`cmd/main`）— 校验 `.nt` 文件并生成 roundtrip 输出

## 许可证

本项目以 MIT 许可证和 Apache License, Version 2.0 双许可发布。详见 `LICENSE`、`LICENSE-MIT` 和 `LICENSE-APACHE`。
