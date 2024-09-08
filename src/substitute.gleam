import gleam/dict.{type Dict}
import gleam/list
import gleam/string

/// Substitute characters in a string using a substitution map.
pub fn substitute(src: String, substitution_map: Dict(String, String)) -> String {
  src
  |> string.to_graphemes
  |> list.map(fn(grapheme) -> String {
    let is_uppercase = string.uppercase(grapheme) == grapheme
    let capitalized = string.uppercase(grapheme)

    case dict.get(substitution_map, capitalized) {
      Ok(substitution) ->
        case is_uppercase {
          True -> string.uppercase(substitution)
          False -> string.lowercase(substitution)
        }
      _ -> grapheme
    }
  })
  |> string.concat
}
