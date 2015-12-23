#!/usr/bin/env ruby

PASSFIRST="a".ord
PASSLAST="z".ord

class SantaPassword
  attr_accessor :password

  def initialize(pass)
    self.password = pass
    @bad_chars = %w[i o l]
  end

  def generate_next!
    begin
      increment!
      # p "Next: #{self.password}"
    end until valid?
  end

  def increment!
    # start at end and work towards the front
    (self.password.size - 1).downto(0) do |i|
      next_char = self.password[i].ord + 1
      next_letter = increment_letter(self.password[i])
      self.password[i] = next_letter
      # if we are resetting this column, move up to next
      break unless next_letter == PASSFIRST.chr
    end
  end

  def increment_letter(letter)
    next_letter = letter.ord + 1
    return "a" if next_letter > PASSLAST # reset to start and kick to next index
    return increment_letter(next_letter.chr) if @bad_chars.include?(next_letter.chr)
    next_letter.chr
  end

  def has_proper_length?(pass=self.password)
    pass.match(/([a-z]+)/).captures[0].length == 8 rescue false
  end

  def has_straight?(pass=self.password)
    pass.chars.each_cons(3) do |chunk|
      if chunk[0].ord + 1 == chunk[1].ord &&
         chunk[1].ord + 1 == chunk[2].ord
        return true
      end
    end
    false
  end

  def has_no_bad_chars?(pass=self.password)
    pass.match(/[iol]/).nil?
  end

  def has_pairs?(pass=self.password)
    pairs = {}
    idx = 0
    pass.chars.each_cons(2) do |chunk|
      # if we have the same two letters and the previous chunk wasn't also a pair
      #     collect the pair. The previous index would trigger if "aaa" was passed.
      if chunk[0] == chunk[1] && pairs[idx-1].nil?
        pairs[idx] = chunk
      end
      idx += 1
    end
    pairs.keys.size >= 2
  end

  def valid?(pass=self.password)
    has_proper_length?(pass)  &&
    has_straight?(pass)       &&
    has_no_bad_chars?(pass)   &&
    has_pairs?(pass)
  end
end

if __FILE__ == $0
  input = ARGV[0] || "hxbxwxba"
  p "CURRENT: #{input}"
  password = SantaPassword.new(input.dup)
  password.generate_next!
  p "NEXT: #{password.password}"
end
