#!/usr/bin/env ruby

def has_vowels?(string, count=3)
  string.scan(/[aeiou]/).count >= count
end

def has_repeating_chars?(string)
  # http://rubular.com/r/cOoUgnfuDd
  string.match(/(.)\1{1}/) != nil
end

def does_not_have_rejects?(string)
  string.match(/(ab|cd|pq|xy)/).nil?
end

def nice_string?(string)
  has_vowels?(string) &&
  has_repeating_chars?(string) &&
  does_not_have_rejects?(string)
end

if __FILE__ == $0
  input = ARGV[0]
  nice_strings = input.lines.find_all { |line| nice_string?(line) }
  puts "Found #{nice_strings.count} nice strings."
end
