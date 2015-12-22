#!/usr/bin/env ruby

require "pp"

class LookAndSay
  attr_accessor :sequence

  def initialize(seq)
    self.sequence = seq
  end

  def parse!
    # break_down = []
    new_sequence = ""
    current = []

    tmp = self.sequence.dup
    until tmp.empty?
      # http://rubular.com/r/wIjDeiXfg7
      if match = tmp.match(/^(\d)\1+/)
        # we have multiple of the same number
        num = match.captures[0]
        match = tmp.match(/^(#{num}+)/)
        s = match.captures[0]
        # break_down << s
        new_sequence << "#{s.size}#{s[0]}"
        tmp = match.post_match
      else
        # we have a single number
        # break_down << tmp[0]
        new_sequence << "1#{tmp[0]}"
        tmp = tmp[1..-1]
      end
    end

    p "BEFORE: #{self.sequence}"
    # create_new_sequence(break_down)
    self.sequence = new_sequence
    p "AFTER:  #{self.sequence}"
  end

  # def create_new_sequence(break_down)
  #   self.sequence = break_down.collect { |chunk| "#{chunk.size}#{chunk[0]}" }.join
  # end
end

if __FILE__ == $0
  input = ARGV[0] || "1321131112"

  lns = LookAndSay.new(input)
  40.times do |i|
    p "Loop: #{i}"
    lns.parse!
    p "Length: #{lns.sequence.length}"
    p "="*80
  end
end
