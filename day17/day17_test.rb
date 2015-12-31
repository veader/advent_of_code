#!/usr/bin/env ruby

require "pp"
require_relative "day17"

nog = Eggnog.new([20, 15, 10, 5, 5], 25)
pp nog.find_container_combinations
