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

def has_repeated_sequence?(string)
  chunks = []
  string.chars.each_cons(2) { |chars| chunks << chars.join }
  chunks.each_with_index do |chunk, idx|
    return true if (chunks[idx+2..-1] || []).include?(chunk)
  end
  return false
end

def has_repeating_chars_offset_by_one?(string)
  string.chars.each_with_index do |char, idx|
    return true if string[idx+2] == char
  end
  return false
end

def nice_string2?(string)
  has_repeated_sequence?(string) &&
  has_repeating_chars_offset_by_one?(string)
end

if __FILE__ == $0
  input = ARGV[0]
  use_second_method = (ARGV[1] == "2")
  method = use_second_method ? :nice_string2? : :nice_string?
  nice_strings = input.lines.find_all { |line| self.send(method, line) }
  puts "Found #{nice_strings.count} nice strings."
end
