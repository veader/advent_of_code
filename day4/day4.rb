#!/usr/bin/env ruby

require 'digest/md5'

def gen_md5(secret, int)
  Digest::MD5.hexdigest("#{secret}#{int}")
end

def md5_match?(md5, num_zeros)
  md5[0,num_zeros] == "0"*num_zeros
end

def mine_for_coins(secret, start=1, num_zeros=5)
  current_int = start
  current_int += 1 until md5_match?(gen_md5(secret, current_int), num_zeros)
  current_int
end

if __FILE__ == $0
  secret = ARGV[0]
  num_zeros = (ARGV[1] || "5").to_i
  first_coin = mine_for_coins(secret, 1, num_zeros)
  puts "Found coin at #{first_coin} => #{gen_md5(secret, first_coin)}"
end
