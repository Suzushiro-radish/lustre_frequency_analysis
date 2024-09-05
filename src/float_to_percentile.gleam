import gleam/float
import gleam/int

/// Convert a float to a percentile
pub fn float_to_percentile(f: Float) -> Float {
  let percentile = f *. 100.0

  // Round to one decimal places
  { percentile *. 10.0 |> float.round |> int.to_float } /. 10.0
}
