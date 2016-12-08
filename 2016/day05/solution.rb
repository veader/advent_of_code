#!/usr/bin/env ruby

require 'digest/md5'

input = 'wtnhxymk'
suffix_index = 0

password_chars = []
password = '_'*8

while password =~ /_/ do
    md5 = Digest::MD5.hexdigest(input + suffix_index.to_s)
    if md5 =~ /^00000/ then
        p "#{input}#{suffix_index} -> #{md5} [#{md5[5]}, #{md5[6]}]"

        password_chars << md5[5] if password_chars.length < 8

        index = md5[5].to_i unless ('a'..'z').include?(md5[5])
        if (0..7).include?(index) then
          password[index] = md5[6] if password[index] == '_'
          p password
        end
    end
    suffix_index += 1
end

p '* Password: ' + password_chars.join('')
p '** Password: ' + password
