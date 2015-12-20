#!/usr/bin/env ruby

class Circuit
  attr_accessor :wires, :wire_cache

  def initialize
    @wires = {}
    @wire_cache = {}
  end

  def wire_up(instructions)
    instructions.each_line do |line|
      pieces = line.split("->").map(&:strip)
      value = pieces.first
      wire_name = pieces.last

      @wires[wire_name] = \
        case value
        when /^\d+$/
          @wire_cache[wire_name] = value.to_i
          value.to_i
        else
          value
        end
    end
  end

  def read_wire_value(wire)
    return @wire_cache[wire] unless @wire_cache[wire].nil?
    return wire.to_i if wire.match(/^\d+$/)

    # p "READ: #{wire} = #{@wires[wire]}"
    @wire_cache[wire] = \
      case (value = @wires[wire].strip)
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
        if @wires.keys.include?(value)
          read_wire_value(value)
        else
          0
        end
      end
  end

  def and_op(str)
    pieces = str.split("AND").map(&:strip)
    read_wire_value(pieces.first) & read_wire_value(pieces.last)
  end

  def or_op(str)
    pieces = str.split("OR").map(&:strip)
    read_wire_value(pieces.first) | read_wire_value(pieces.last)
  end

  def not_op(str)
    wire_name = str.gsub("NOT", "").strip
    ~read_wire_value(wire_name)
  end

  def lshift_op(str)
    pieces = str.split("LSHIFT").map(&:strip)
    read_wire_value(pieces.first) << pieces.last.to_i
  end

  def rshift_op(str)
    pieces = str.split("RSHIFT").map(&:strip)
    read_wire_value(pieces.first) >> pieces.last.to_i
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
      value = read_wire_value(wire)
      p "#{wire} -> #{print_bits(value)} | #{as_unit(value)}"
    end
  end

end

if __FILE__ == $0
  input = ARGV[0]
  wire = ARGV[1]
  circ = Circuit.new
  circ.wire_up(input)
  circ.print
  p "="*30
  p "#{wire} -> #{circ.read_wire_value(wire)}"
end
