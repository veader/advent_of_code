#!/usr/bin/env ruby

# require "json"
require "pp"

class AddDoc
  attr_accessor :json_doc, :string_doc

  def initialize(string_doc="{}")
    self.string_doc = string_doc
  end

  def hack_add
    # http://rubular.com/r/IdGOuagaw6
    pp scanned = self.string_doc.scan(/([\-\+]?\d+)/)
    pp numbers = scanned.map(&:first).map(&:to_i)
    numbers.reduce(:+) || 0
  end

  # def parse_json!
  #   self.json_doc = JSON.parse(self.string_doc)
  # end
end

if __FILE__ == $0
  input = ARGV[0]
  doc = AddDoc.new(input)
  p "Sum: (HACK) #{doc.hack_add}"
end
