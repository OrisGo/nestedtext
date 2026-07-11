///|
/// Constraint for the top-level value accepted by `loads`.
///
/// # Variants
/// * `Dict` — The document must be a dictionary (key-value pairs). An empty
///   document yields an empty dictionary.
/// * `List` — The document must be a list. An empty document yields an empty
///   list.
/// * `String` — The document must be a single string scalar. An empty document
///   yields the empty string `""`.
/// * `Any` — The document may be any type. An empty document yields `None`.
pub(all) enum Top {
  Dict
  List
  String
  Any
} derive(Debug, Eq)
