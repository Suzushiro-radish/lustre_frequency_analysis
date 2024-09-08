import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

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
  Model(
    input: String,
    frequency_map: Dict(String, Int),
    substitution: Dict(String, String),
    output: String,
  )
}

fn init(initial_str: String) -> Model {
  Model(
    input: initial_str,
    frequency_map: get_char_count(initial_str),
    substitution: dict.new(),
    output: "",
  )
}

pub type Msg {
  Add(String)
  Calculate
  ChangeTargetChar(source: String, target: String)
  Substitute
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    Add(txt) ->
      Model(txt, model.frequency_map, model.substitution, model.output)
    Calculate ->
      Model(
        model.input,
        get_char_count(model.input),
        model.substitution,
        model.output,
      )
    ChangeTargetChar(source, target) ->
      Model(
        model.input,
        model.frequency_map,
        model.substitution |> dict.upsert(source, fn(_) { target }),
        model.output,
      )
    Substitute ->
      Model(
        model.input,
        model.frequency_map,
        model.substitution,
        substitute(model.input, model.substitution),
      )
  }
}

fn view(model: Model) -> element.Element(Msg) {
  let frequency_list = model.frequency_map |> dict.to_list
  let total_chars =
    frequency_list |> list.map(fn(frequency) { frequency.1 }) |> int.sum

  let change_target_char = fn(event) {
    use target <- result.try(dynamic.field("target", dynamic.dynamic)(event))
    use key <- result.try(dynamic.field("name", dynamic.string)(target))
    use value <- result.try(dynamic.field("value", dynamic.string)(target))

    case string.length(value) {
      1 -> ChangeTargetChar(key, value)
      0 -> ChangeTargetChar(key, "")
      _ -> ChangeTargetChar(key, string.first(value) |> result.unwrap(""))
    }
    |> Ok
  }

  html.main([attribute.class("bg-slate-100 p-8")], [
    html.h1([attribute.class("text-2xl")], [
      element.text("Lustre Frequency Analysis"),
    ]),
    // Input for source text.
    html.textarea(
      [event.on_input(Add), attribute.class("w-full h-40")],
      model.input,
    ),
    // Buttons for calculating the frequency of characters.
    html.button(
      [event.on_click(Calculate), attribute.class("bg-blue-500 text-white p-2")],
      [element.text("Calculate")],
    ),
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
            html.input([
              attribute.name(grapheme),
              event.on("input", change_target_char),
              attribute.class("w-8"),
              attribute.value(
                model.substitution |> dict.get(grapheme) |> result.unwrap(""),
              ),
              attribute.max("1"),
            ]),
          ])
        }),
    ),
    html.button(
      [
        event.on_click(Substitute),
        attribute.class("bg-blue-500 text-white p-2"),
      ],
      [element.text("Substitute")],
    ),
    html.textarea(
      [attribute.readonly(True), attribute.class("w-full h-40")],
      model.output,
    ),
  ])
}

fn substitute(src: String, substitution_map: Dict(String, String)) -> String {
  src
  |> string.to_graphemes
  |> list.map(fn(grapheme) -> String {
    case dict.get(substitution_map, grapheme) {
      Ok(substitution) -> substitution
      _ -> grapheme
    }
  })
  |> string.concat
}
