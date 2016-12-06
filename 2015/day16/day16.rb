#!/usr/bin/env ruby

require "pp"

SUEATTR_REGEX=/(\S+): (\d+)/

class AuntSue
  attr_accessor :attributes, :num

  def initialize(input="")
    self.attributes = {}
    parse(input)
  end

  def parse(input)
    if match = input.match(/Sue (\d+): (.*)/)
      self.num = match.captures[0].to_i
      pieces = match.captures[1].split(",").map(&:strip)
      pieces.each do |piece|
        next unless match = piece.match(SUEATTR_REGEX)
        self.attributes[match.captures[0]] = match.captures[1].to_i
      end
    end
  end

  def match_score(attribs)
    score = 0
    # get one point for each attrib that matches
    attribs.each do |attrib, value|
      next if self.attributes[attrib].nil?
      score +=
        case attrib
        when "cats", "trees"
          (self.attributes[attrib] > value) ? 1 : 0
        when "pomeranians", "goldfish"
          (self.attributes[attrib] < value) ? 1 : 0
        else
          (self.attributes[attrib] == value) ? 1 : 0
        end
    end
    score
  end
end

class SueList
  attr_accessor :sues

  def initialize(input="")
    self.sues = []
    parse(input)
  end

  def parse(input)
    input.each_line do |line|
      self.sues << AuntSue.new(line)
    end
  end

  def find_sue_matching(attribs)
    sue_match = {}

    self.sues.each do |sue|
      score = sue.match_score(attribs)
      sue_match[score] ||= []
      sue_match[score] << sue
    end

    max_match = sue_match.keys.sort.reverse.first
    p "Max Score: #{max_match}"
    pp sue_match[max_match]
  end
end

def parse_attributes(input)
  attribs = {}
  input.each_line do |line|
    next unless match = line.match(SUEATTR_REGEX)
    attribs[match.captures[0]] = match.captures[1].to_i
  end
  attribs
end

if __FILE__ == $0
  input = ARGV[0]
  attrib_input = ARGV[1]

  list = SueList.new(input)
  pp list
  p "="*80

  attribs = parse_attributes(attrib_input)
  pp attribs
  p "="*80

  list.find_sue_matching(attribs)
end
