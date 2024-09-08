import gleam/dict
import gleam/list

import gleeunit
import gleeunit/should

import get_char_count.{get_char_count}
import constants.{alphabets}

pub fn main() {
  gleeunit.main()
}

pub fn get_char_count_test() {
  let test_text = "Hello, world!"

  let expected = dict.from_list(list.map(alphabets, fn(c) { #(c, 0) }))
  let expected = dict.upsert(expected, "D", fn(_) { 1 })
  let expected = dict.upsert(expected, "E", fn(_) { 1 })
  let expected = dict.upsert(expected, "H", fn(_) { 1 })
  let expected = dict.upsert(expected, "L", fn(_) { 3 })
  let expected = dict.upsert(expected, "O", fn(_) { 2 })
  let expected = dict.upsert(expected, "R", fn(_) { 1 })
  let expected = dict.upsert(expected, "W", fn(_) { 1 })

  let actual = get_char_count(test_text)
  should.equal(expected, actual)
}

pub fn get_char_count_empty_test() {
  let test_text = ""
  let expected = dict.from_list(list.map(alphabets, fn(c) { #(c, 0) }))
  let actual = get_char_count(test_text)
  should.equal(expected, actual)
}

pub fn chars_not_alphabets_skipped_test() {
  let test_text = "Hello, world! 123"

  let expected = dict.from_list(list.map(alphabets, fn(c) { #(c, 0) }))
  let expected = dict.upsert(expected, "D", fn(_) { 1 })
  let expected = dict.upsert(expected, "E", fn(_) { 1 })
  let expected = dict.upsert(expected, "H", fn(_) { 1 })
  let expected = dict.upsert(expected, "L", fn(_) { 3 })
  let expected = dict.upsert(expected, "O", fn(_) { 2 })
  let expected = dict.upsert(expected, "R", fn(_) { 1 })
  let expected = dict.upsert(expected, "W", fn(_) { 1 })

  let actual = get_char_count(test_text)
  should.equal(expected, actual)
}
