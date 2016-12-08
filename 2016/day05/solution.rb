#!/usr/bin/env ruby

require 'digest/md5'

input = 'wtnhxymk'
suffix_index = 0
password_chars = []

while password_chars.length < 8 do
    md5 = Digest::MD5.hexdigest(input + suffix_index.to_s)
    if md5 =~ /^00000/ then
        p "#{input}#{suffix_index} -> #{md5}"
        password_chars << md5[5]
    end
    suffix_index += 1
end

p 'Password: ' + password_chars.join('')
