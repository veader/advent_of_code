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

  def expanding_substitutions_of(input="")
    substitutions_of(true, input)
  end

  def reducing_substitutions_of(input="")
    substitutions_of(false, input)
  end

  # return a list of possible substitutions for this replacement
  def substitutions_of(expanding, input="")
    original = (expanding ? self.initial : self.substitution)
    replacement = (expanding ? self.substitution : self.initial)
    regex = /#{original}/

    subs = []
    the_prev = ""
    the_rest = input
    until the_rest.empty?
      match = the_rest.match(regex)
      break if match.nil?
      the_rest = match.post_match
      subs << "#{the_prev}#{match.pre_match}#{replacement}#{the_rest}"
      the_prev += (match.pre_match + original)
    end
    subs
  end

  def self.match?(input="")
    ! input.match(REP_REGEX).nil?
  end
end

class Medicine
  attr_accessor :replacements, :final_formula

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
        self.final_formula = line.chomp.strip
      end
    end
  end

  def shortest_path_to_med(depth=0, current_depth=["e"])
    p "#{Time.now} Depth: #{depth} | Num: #{current_depth.size} | Sample Length: #{(current_depth.first || '').length} | Final: #{self.final_formula.length}"

    # find the next layer of the stack
    next_depth = []
    current_depth.each do |molecule|
      next_batch = find_new_molecules(molecule)
      return [self.final_formula] if next_batch.include?(self.final_formula)
      next_depth += next_batch
    end

    # go deeper into the stack
    results = shortest_path_to_med(depth+1, next_depth)
    # return our depth plus deeper depths
    [current_depth] + results
  end

  def find_new_molecules(m=self.final_formula)
    subs = []
    self.replacements.each do |rep|
      subs += rep.expanding_substitutions_of(m)
    end
    subs
  end

  def print
    p "Molecule: #{self.final_formula}"
    p "Replacements:"
    pp self.replacements
  end
end

if __FILE__ == $0
  input = ARGV[0]
  med = Medicine.new(input)
  # med.print
  # p "="*80
  # molecules = med.find_new_molecules
  # p "Found #{molecules.size} new molecules. #{molecules.uniq.size} unique ones."
  solutions = med.shortest_path_to_med
  p "Found solution in #{solutions.size} steps"
end
