import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub fn get_char_count(text: String) -> Dict(String, Int) {
  let grapheme_list =
    list.range(char_to_charcode("A"), char_to_charcode("Z"))
    |> list.map(fn(code) { string.utf_codepoint(code) })
    |> list.map(fn(c) {
      case c {
        Ok(grapheme) -> [grapheme] |> string.from_utf_codepoints
        Error(_) -> ""
      }
    })
    |> list.filter(fn(c) { c != "" })

  let grapheme_dict =
    dict.from_list(grapheme_list |> list.map(fn(c) { #(c, 0) }))

  text
  |> string.uppercase
  |> string.to_graphemes
  |> list.fold(grapheme_dict, fn(acc, grapheme) {
    case is_ascii_alpha(grapheme) {
      True -> dict.upsert(acc, grapheme, inclement)
      False -> acc
    }
  })
}

fn inclement(x: Option(Int)) -> Int {
  case x {
    Some(n) -> n + 1
    None -> 1
  }
}

/// Check if a single character is an ASCII letter.
fn is_ascii_alpha(c: String) -> Bool {
  let char_code = char_to_charcode(c)

  char_to_charcode("a") <= char_code
  && char_code <= char_to_charcode("z")
  || char_to_charcode("A") <= char_code
  && char_code <= char_to_charcode("Z")
}

/// Convert a single character to its Unicode code point.
fn char_to_charcode(c: String) -> Int {
  string.to_utf_codepoints(c)
  |> list.map(fn(cp) { string.utf_codepoint_to_int(cp) })
  |> list.first
  |> result.unwrap(0)
}
