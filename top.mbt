///|
/// Constraint for the top-level value accepted by `loads`.
pub(all) enum Top {
  Dict
  List
  String
  Any
} derive(Debug, Eq)
