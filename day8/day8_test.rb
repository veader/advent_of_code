#!/usr/bin/env ruby

require_relative "day8"

strF = StringFile.new
strF.read(
'""
"abc"
"aaa\"aaa"
"\x27"')

strF.print_lengths

p strF.overall_length
p strF.overall_escaped_length
