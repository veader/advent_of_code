#!/usr/bin/env ruby

class Circuit
  attr_accessor :wires

  def initialize
    @wires = {}
  end

  def parse_instructions(instructions)
    instructions.each_line do |line|
      pieces = line.split("->").map(&:strip)
      value = pieces.first
      wire_name = pieces.last

      # p "#{wire_name} BEFORE #{print_bits(@wires[wire_name] || 0)}"
      @wires[wire_name] = \
        case value
        when /^\d+$/
          value.to_i
        when /AND/
          and_op(value)
        when /OR/
          or_op(value)
        when /LSHIFT/
          lshift_op(value)
        when /RSHIFT/
          rshift_op(value)
        when /^NOT/
          not_op(value)
        else
          @wires[wire_name]
        end
      # p "#{wire_name} AFTER  #{print_bits(@wires[wire_name])}"
    end
  end

  def and_op(str)
    pieces = str.split("AND").map(&:strip)
    (@wires[pieces.first] || 0) & (@wires[pieces.last] || 0)
  end

  def or_op(str)
    pieces = str.split("OR").map(&:strip)
    (@wires[pieces.first] || 0) | (@wires[pieces.last] || 0)
  end

  def not_op(str)
    wire_name = str.gsub("NOT", "").strip
    ~(@wires[wire_name] || 0)
  end

  def lshift_op(str)
    pieces = str.split("LSHIFT").map(&:strip)
    (@wires[pieces.first] || 0) << pieces.last.to_i
  end

  def rshift_op(str)
    pieces = str.split("RSHIFT").map(&:strip)
    (@wires[pieces.first] || 0) >> pieces.last.to_i
  end

  def print_bits(int)
    15.downto(0).map { |bit| int[bit] }.join
  end

  def as_unit(int)
    sum = 0
    15.downto(0).map { |bit| sum += 2**bit if int[bit] == 1 }
    sum
  end

  def print
    @wires.keys.sort.each do |wire|
      value = (@wires[wire] || 0)
      p "#{wire} -> #{print_bits(value)} | #{as_unit(value)}"
    end
  end

end

if __FILE__ == $0
  input = ARGV[0]
  circ = Circuit.new
  circ.parse_instructions(input)
  circ.print
end
