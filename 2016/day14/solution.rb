#!/usr/bin/env ruby

require 'digest/md5'

MD5_HASHES = []
SALT = 'ahsbgdzn'
STRETCH_REPEAT = 2017 # part 1 = 1

found_keys = []
index = 1

# http://rubular.com/r/nyLjJSQYBd
triple_regex = /(.)\1{2}/

def make_key(idx)
    (SALT + idx.to_s).downcase
end

def make_hash(key, repeat=STRETCH_REPEAT)
    output = key
    repeat.times do |i|
        output = Digest::MD5.hexdigest(output).downcase
    end
    return output
end

def is_valid_key?(idx, char)
    idx += 1 # move past our current index

    1000.times do |offset|
        new_index = idx + offset
        key = make_key(new_index)
        md5 = MD5_HASHES[new_index] || make_hash(key)
        MD5_HASHES[new_index] = md5 if MD5_HASHES[new_index].nil?

        return true if match = /#{char}{5}/.match(md5)
    end

    return false
end

while found_keys.count < 64 do
    key = make_key(index)
    md5 = MD5_HASHES[index] || make_hash(key)
    MD5_HASHES[index] = md5 if MD5_HASHES[index].nil?

    if match = triple_regex.match(md5) then
        if is_valid_key?(index, match[1])
            p "Found Key: #{key} @ #{index}"
            found_keys << key
        end
    end

    index += 1
end

p "Index: #{index-1}"
