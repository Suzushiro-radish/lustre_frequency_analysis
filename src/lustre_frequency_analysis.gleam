import gleam/int
import gleam/dict.{type Dict}
import gleam/list

import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

import get_char_count.{get_char_count}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", "Hello, world!")

  Nil
}

type Model {
  Model(input: String, frequency_map: Dict(String, Int))
}

fn init(initial_str: String) -> Model {
  Model(input: initial_str, frequency_map: get_char_count(initial_str))
}

pub type Msg {
  Add(txt: String)
  Remove
}

fn update(_model: Model, msg: Msg) -> Model {
  case msg {
    Add(txt) -> Model(txt, get_char_count(txt))
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
