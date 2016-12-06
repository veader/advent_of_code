#!/usr/bin/env ruby

require_relative "day11"

password = SantaPassword.new("testing")

[%w[abcdefgh abcdffaa], %w[ghijklmn ghjaabcc]].each do |passwords|
  passwd = passwords.first
  next_passwd = passwords.last
  password.password = passwd
  password.generate_next!
  raise "Next password should be #{next_passwd} not #{password.password}" unless next_passwd == password.password
end

passwd = "hijklmmn"
p "Testing #{passwd}..."
raise "Password should have straight [#{passwd}]" unless password.has_straight?(passwd)
raise "Password should have bad chars [#{passwd}]" if password.has_no_bad_chars?(passwd)
raise "Password should not have pairs [#{passwd}]" if password.has_pairs?(passwd)

passwd = "abbceffg"
p "Testing #{passwd}..."
raise "Password should not have straight [#{passwd}]" if password.has_straight?(passwd)
raise "Password should not have bad chars [#{passwd}]" unless password.has_no_bad_chars?(passwd)
raise "Password should have pairs [#{passwd}]" unless password.has_pairs?(passwd)

passwd = "abbcegjk"
p "Testing #{passwd}..."
raise "Password should not have straight [#{passwd}]" if password.has_straight?(passwd)
raise "Password should not have bad chars [#{passwd}]" unless password.has_no_bad_chars?(passwd)
raise "Password should not have pairs [#{passwd}]" if password.has_pairs?(passwd)

passwd = "aaa"
raise "'#{passwd}' should not have pairs" if password.has_pairs?(passwd)
passwd = "abcd"
raise "'#{passwd}' should not have pairs" if password.has_pairs?(passwd)
passwd = "aabb"
raise "'#{passwd}' should have pairs" unless password.has_pairs?(passwd)

passwd = "12345"
raise "'#{passwd}' is not proper length" if password.has_proper_length?(passwd)
passwd = "abcd"
raise "'#{passwd}' is not proper length" if password.has_proper_length?(passwd)
passwd = "abcdefg1"
raise "'#{passwd}' is not proper length" if password.has_proper_length?(passwd)
passwd = "abcdefgh"
raise "'#{passwd}' is proper length" unless password.has_proper_length?(passwd)
