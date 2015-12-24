#!/usr/bin/env ruby

require "pp"

class LookAndSay
  attr_accessor :sequence

  def initialize(seq)
    self.sequence = seq
  end

  def parse!
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
        new_sequence << "#{s.size}#{s[0]}"
        tmp = match.post_match
      else
        # we have a single number
        new_sequence << "1#{tmp[0]}"
        tmp = tmp[1..-1]
      end
    end

    # p "BEFORE: #{self.sequence}"
    self.sequence = new_sequence
    # p "AFTER:  #{self.sequence}"
  end
end

if __FILE__ == $0
  input = ARGV[0] || "1321131112"

  lns = LookAndSay.new(input)
  50.times do |i|
    p "Loop: #{i+1}"
    lns.parse!
    p "Length: #{lns.sequence.length}"
    p "="*80
  end
end
