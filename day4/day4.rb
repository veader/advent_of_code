#!/usr/bin/env ruby

require 'digest/md5'

def gen_md5(secret, int)
  Digest::MD5.hexdigest("#{secret}#{int}")
end

def md5_match?(md5)
  md5[0,5] == "0"*5
end

def mine_for_coins(secret, start=1)
  current_int = start
  current_int += 1 until md5_match?(gen_md5(secret, current_int))
  current_int
end

if __FILE__ == $0
  secret = ARGV[0]
  first_coin = mine_for_coins(secret)
  puts "Found coin at #{first_coin} => #{gen_md5(secret, first_coin)}"
end
