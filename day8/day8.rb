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

  def overall_length
    total_chars = @strings.inject(0) { |sum, s| sum + char_length(s) }
    total_inmem = @strings.inject(0) { |sum, s| sum + in_memory_length(s) }
    total_chars - total_inmem
  end
end

if __FILE__ == $0
  input = ARGV[0]
  strF = StringFile.new
  strF.read(input)
  p "Overall: #{strF.overall_length}"
end
