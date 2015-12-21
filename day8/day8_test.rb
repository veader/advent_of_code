#!/usr/bin/env ruby

require_relative "day8"

strF = StringFile.new
strF.read(
'""
"abc"
"aaa\"aaa"
"\x27"')

p strF.overall_length
