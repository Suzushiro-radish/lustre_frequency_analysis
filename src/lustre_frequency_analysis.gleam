import gleam/result
import gleam/int
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}
import gleam/string

import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", "Hello, world!")

  Nil
}

type Model {
  Model(input: String, frequency_map: dict.Dict(String, Int))
}

fn init(initial_str: String) -> Model {
  Model(input: initial_str, frequency_map: frequency_analysis(initial_str))
}

pub type Msg {
  Add(txt: String)
  Remove
}

fn update(_model: Model, msg: Msg) -> Model {
  case msg {
    Add(txt) -> Model(txt, frequency_analysis(txt))
    Remove -> Model(input: "", frequency_map: dict.new())
  }
}

fn view(model: Model) -> element.Element(Msg) {
  html.div([], [
    html.h1([], [element.text("Lustre Frequency Analysis")]),
    html.input([attribute.value(model.input), event.on_input(Add)]),
    html.button([event.on_click(Remove)], [element.text("Remove")]),
    html.p([], [element.text(model.input)]),

    html.ul([],
      model.frequency_map
      |> dict.to_list
      |> list.map(fn(frequency) -> element.Element(Msg) {
        let #(grapheme, count) = frequency
        html.li([], [element.text(grapheme <> ": " <> int.to_string(count) )])
      }),
    ),
  ])
}

fn frequency_analysis(text: String) -> Dict(String, Int) {
  text
  |> string.lowercase
  |> string.to_graphemes
  |> list.fold(dict.new(), fn(acc, grapheme) {
    case is_ascii_alpha(grapheme) {
      True -> dict.upsert(acc, grapheme, inclement)
      False -> acc
    }
  })
}

fn inclement(x: option.Option(Int)) -> Int {
  case x {
    Some(n) -> n + 1
    None -> 1
  }
}

/// Check if a single character is an ASCII letter.
fn is_ascii_alpha(c: String) -> Bool {
  let char_code = char_to_charcode(c)

  char_to_charcode("a") <= char_code && char_code <= char_to_charcode("z") || char_to_charcode("A") <= char_code && char_code <= char_to_charcode("Z")
}

/// Convert a single character to its Unicode code point.
fn char_to_charcode(c: String) -> Int {
  string.to_utf_codepoints(c) |> list.map(fn(cp) {string.utf_codepoint_to_int(cp)}) |> list.first |> result.unwrap(0)
}