#!/usr/bin/env ruby

require "json"
require "pp"

class AddDoc
  attr_accessor :json_doc, :string_doc

  def initialize(string_doc="{}")
    @found_numbers = []

    self.string_doc = string_doc
    parse_json!
    find_numbers(self.json_doc)
  end

  def hack_add
    # http://rubular.com/r/IdGOuagaw6
    pp scanned = self.string_doc.scan(/([\-\+]?\d+)/)
    pp numbers = scanned.map(&:first).map(&:to_i)
    numbers.reduce(:+) || 0
  end

  def parse_json!
    self.json_doc = JSON.parse(self.string_doc)
  end

  def find_numbers(element)
    # walk the JSON element and find numbers
    if element.is_a?(Hash) # ---- Object
      return if element.values.include?("red")
      element.values.each do |val|
        if val.is_a?(Fixnum)
          @found_numbers << val
        else
          find_numbers(val)
        end
      end
    elsif element.is_a?(Array) # ---- Array
      element.each do |item|
        if item.is_a?(Fixnum)
          @found_numbers << item
        else
          find_numbers(item)
        end
      end
    else
      p "What is this? '#{element}'"
    end
  end

  def sum
    p "Found: #{@found_numbers}"
    @found_numbers.reduce(:+) || 0
  end
end

if __FILE__ == $0
  input = ARGV[0]
  doc = AddDoc.new(input)
  p "Sum: (HACK) #{doc.hack_add}"
  p "Sum: #{doc.sum}"
end
