import get_char_count
import gleam/dict

import gleeunit
import gleeunit/should


pub fn main() {
  gleeunit.main()
}

pub fn get_char_count_test() {
  let test_text = "Hello, world!"
  let expected = dict.from_list([
    #("h", 1),
    #("e", 1),
    #("l", 3),
    #("o", 2),
    #("w", 1),
    #("r", 1),
    #("d", 1),
  ])
  let actual = get_char_count.get_char_count(test_text)
  should.equal(expected, actual)
}

pub fn get_char_count_empty_test() {
  let test_text = ""
  let expected = dict.new()
  let actual = get_char_count.get_char_count(test_text)
  should.equal(expected, actual)
}

pub fn chars_not_alphabets_skipped_test() {
  let test_text = "Hello, world! 123"
  let expected = dict.from_list([
    #("h", 1),
    #("e", 1),
    #("l", 3),
    #("o", 2),
    #("w", 1),
    #("r", 1),
    #("d", 1),
  ])
  let actual = get_char_count.get_char_count(test_text)
  should.equal(expected, actual)
}