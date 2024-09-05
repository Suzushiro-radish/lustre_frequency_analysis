import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list

import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

import float_to_percentile.{float_to_percentile}
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
  let frequency_list = model.frequency_map |> dict.to_list
  let total_chars =
    frequency_list |> list.map(fn(frequency) { frequency.1 }) |> int.sum

  html.main([attribute.class("bg-slate-100 p-8")], [
    html.h1([attribute.class("text-2xl")], [
      element.text("Lustre Frequency Analysis"),
    ]),
    html.textarea([event.on_input(Add)], model.input),
    html.div(
      [attribute.class("flex flex-wrap space-x-4")],
      frequency_list
        |> list.map(fn(frequency) -> element.Element(Msg) {
          let #(grapheme, count) = frequency
          html.div([attribute.class("w-16 py-2")], [
            element.text(grapheme <> ": " <> int.to_string(count)),
            html.p([], [
              element.text(
                float.to_string(float_to_percentile(
                  int.to_float(count) /. int.to_float(total_chars),
                ))
                <> "%",
              ),
            ]),
            html.input([attribute.class("w-8")]),
          ])
        }),
    ),
  ])
}
