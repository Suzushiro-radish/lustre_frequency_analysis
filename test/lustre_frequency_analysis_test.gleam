import get_char_count
import gleam/dict

import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn get_char_count_test() {
  let test_text = "Hello, world!"
  let expected =
    dict.from_list([
      #("A", 0),
      #("B", 0),
      #("C", 0),
      #("D", 1),
      #("E", 1),
      #("F", 0),
      #("G", 0),
      #("H", 1),
      #("I", 0),
      #("J", 0),
      #("K", 0),
      #("L", 3),
      #("M", 0),
      #("N", 0),
      #("O", 2),
      #("P", 0),
      #("Q", 0),
      #("R", 1),
      #("S", 0),
      #("T", 0),
      #("U", 0),
      #("V", 0),
      #("W", 1),
      #("X", 0),
      #("Y", 0),
      #("Z", 0),
    ])
  let actual = get_char_count.get_char_count(test_text)
  should.equal(expected, actual)
}

pub fn get_char_count_empty_test() {
  let test_text = ""
  let expected =
    dict.from_list([
      #("A", 0),
      #("B", 0),
      #("C", 0),
      #("D", 0),
      #("E", 0),
      #("F", 0),
      #("G", 0),
      #("H", 0),
      #("I", 0),
      #("J", 0),
      #("K", 0),
      #("L", 0),
      #("M", 0),
      #("N", 0),
      #("O", 0),
      #("P", 0),
      #("Q", 0),
      #("R", 0),
      #("S", 0),
      #("T", 0),
      #("U", 0),
      #("V", 0),
      #("W", 0),
      #("X", 0),
      #("Y", 0),
      #("Z", 0),
    ])
  let actual = get_char_count.get_char_count(test_text)
  should.equal(expected, actual)
}

pub fn chars_not_alphabets_skipped_test() {
  let test_text = "Hello, world! 123"
  let expected =
    dict.from_list([
      #("A", 0),
      #("B", 0),
      #("C", 0),
      #("D", 1),
      #("E", 1),
      #("F", 0),
      #("G", 0),
      #("H", 1),
      #("I", 0),
      #("J", 0),
      #("K", 0),
      #("L", 3),
      #("M", 0),
      #("N", 0),
      #("O", 2),
      #("P", 0),
      #("Q", 0),
      #("R", 1),
      #("S", 0),
      #("T", 0),
      #("U", 0),
      #("V", 0),
      #("W", 1),
      #("X", 0),
      #("Y", 0),
      #("Z", 0),
    ])
  let actual = get_char_count.get_char_count(test_text)
  should.equal(expected, actual)
}
