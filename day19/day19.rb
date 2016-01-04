#!/usr/bin/env ruby

require "pp"

class Replacement
  attr_accessor :initial, :substitution

  # http://rubular.com/r/z04mUVGjAw
  REP_REGEX=/(\S+) => (\S+)/

  def initialize(input="")
    parse(input)
  end

  def parse(input="")
    return unless match = input.match(REP_REGEX)
    self.initial = match.captures[0]
    self.substitution = match.captures[1]
  end

  # return a list of possible substitutions for this replacement
  def substitutions_of(input="")
    # p "** #{self.initial} => #{self.substitution}"
    subs = []
    the_prev = ""
    the_rest = input
    until the_rest.empty?
      # p "PREV: #{the_prev}: REST #{the_rest}"
      match = the_rest.match(/#{self.initial}/)
      break if match.nil?
      the_rest = match.post_match
      subs << "#{the_prev}#{match.pre_match}#{substitution}#{the_rest}"
      the_prev += (match.pre_match + self.initial)
    end
    # pp subs
    subs
  end

  def self.match?(input="")
    ! input.match(REP_REGEX).nil?
  end
end

class Medicine
  attr_accessor :replacements, :molecule

  def initialize(input="")
    self.replacements = []
    parse(input)
  end

  def parse(input="")
    input.lines.each do |line|
      next if line.chomp.strip.empty?
      if Replacement.match?(line)
        self.replacements << Replacement.new(line)
      else
        self.molecule = line.chomp.strip
      end
    end
  end

  def find_new_molecules
    subs = []
    self.replacements.each do |rep|
      subs += rep.substitutions_of(self.molecule)
    end
    subs
  end

  def print
    p "Molecule: #{self.molecule}"
    p "Replacements:"
    pp self.replacements
  end
end

if __FILE__ == $0
  input = ARGV[0]
  med = Medicine.new(input)
  med.print
  p "="*80
  molecules = med.find_new_molecules
  p "Found #{molecules.size} new molecules. #{molecules.uniq.size} unique ones."
end
