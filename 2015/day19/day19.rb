#!/usr/bin/env ruby

require "pp"

EXPAND=true
REDUCE=false

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
    substitutions_of(EXPAND, input)
  end

  def reducing_substitutions_of(input="")
    substitutions_of(REDUCE, input)
  end

  # return a list of possible substitutions for this replacement
  def substitutions_of(expanding=EXPAND, input="")
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

  def shortest_path_to_med(answer, depth=0, current_depth=[self.final_formula])
    p "#{Time.now} Depth: #{depth} | Num: #{current_depth.size}"

    # find the next layer of the stack
    next_depth = []
    current_depth.each do |molecule|
      next_batch = find_new_molecules(molecule, REDUCE)
      if next_batch.include?(answer)
        p "Found solution in #{depth+1} steps"
        return
      else
        next_depth += next_batch
      end
    end

    next_depth = next_depth.sort_by { |m| m.size }
    p "Sizes:"
    sizes = next_depth.collect(&:size).uniq
    pp sizes
    shortest = sizes.first
    # find only the shortest ones
    shortest_next_steps = next_depth.find_all { |m| m.size == shortest }

    # go deeper into the stack
    results = shortest_path_to_med(answer, depth+1, shortest_next_steps)
    # # return our depth plus deeper depths
    # [current_depth] + results
  end

  def find_new_molecules(m=self.final_formula, expand=EXPAND)
    subs = []
    self.replacements.each do |rep|
      if expand
        subs += rep.expanding_substitutions_of(m)
      else
        subs += rep.reducing_substitutions_of(m)
      end
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
  med.shortest_path_to_med("e")
end
