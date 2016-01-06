#!/usr/bin/env ruby

require "pp"

class House
  attr_accessor :number, :elves_that_visit, :presents_delivered

  def initialize(num=0)
    self.number = num.to_i # in case it's a string

    self.presents_delivered = 0
    self.elves_that_visit = []

    determine_present_count
  end

  def determine_present_count
    self.presents_delivered = 0

    (self.number).downto(1) do |i|
      if (self.number % i) == 0
        # self.elves_that_visit << i
        self.presents_delivered += (i * 10)
      end
    end

    self.presents_delivered
  end
end

def pn(number)
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

# find first house over total
def search_by(step_count, total_presents, start=0)
  p "Search by: #{pn(step_count)} for #{pn(total_presents)} starting at #{pn(start)}"
  presents = 0
  house_num = start
  house = House.new(0) # remove obj creation "cost"
  while presents < total_presents
    house_num += step_count
    house.number = house_num
    presents = house.determine_present_count
  end
  p "House (#{pn(house_num)}) => #{pn(presents)}"
  house_num
end

if __FILE__ == $0
  total_presents = (ARGV[0] || 36000000).to_i

  start_house = 0
  house_num = -1
  step = 10000
  until step < 1
    house_num = search_by(step, total_presents, start_house)
    start_house = house_num - ((house_num - start_house) / 2)
    step = step / 10
    puts
  end

  p "Found the first house to have at least #{pn(total_presents)} presents was #{house_num}."
end
