#!/usr/bin/env ruby

class StringFile
  attr_accessor :strings

  def initialize
    @strings = []
  end

  def read(input)
    input.each_line do |line|
      @strings << (l = line.chomp)
      # p "#{line} -> #{char_length(l)} : #{in_memory_length(l)}"
    end
  end

  def char_length(str)
    str.length
  end

  def in_memory_length(str)
    eval(str).length
  end

  def escape_length(str)
    len = char_length(str)
    str.chars.each { |c| len += 1 if c == %Q["] || c == "\\"}
    len + 2
  end

  def print_lengths
    @strings.each do |str|
      p "#{str} -> #{char_length(str)} : #{in_memory_length(str)} : #{escape_length(str)}"
    end
  end

  def overall_length
    total_chars = @strings.inject(0) { |sum, s| sum + char_length(s) }
    total_inmem = @strings.inject(0) { |sum, s| sum + in_memory_length(s) }
    p "Chars: #{total_chars} - InMem: #{total_inmem}"
    total_chars - total_inmem
  end

  def overall_escaped_length
    total_chars = @strings.inject(0) { |sum, s| sum + char_length(s) }
    total_esc   = @strings.inject(0) { |sum, s| sum + escape_length(s) }
    p "Esc: #{total_esc} - Chars: #{total_chars}"
    total_esc - total_chars
  end
end

if __FILE__ == $0
  input = ARGV[0]
  strF = StringFile.new
  strF.read(input)
  p "Overall: #{strF.overall_length}"
  p "Escaped: #{strF.overall_escaped_length}"

  strF.print_lengths
end
