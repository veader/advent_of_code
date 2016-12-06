#!/usr/bin/env ruby
require "pp"

class Reindeer
  attr_accessor :name, :speed, :running_duration, :rest_duration

  def initialize(name, speed, run, rest)
    self.name = name
    self.speed = speed
    self.running_duration = run
    self.rest_duration = rest
  end

  def distance_traveled_in(seconds)
    distance = 0
    run_rest_time = self.running_duration + self.rest_duration
    whole, secs_remaining = seconds.divmod(run_rest_time)
    distance = (self.speed * self.running_duration) * whole
    # p "#{self.name} can travel #{distance} in #{whole * run_rest_time} seconds (#{self.speed} km/s for #{self.running_duration} and resting for #{self.rest_duration})"
    # p "Remaining seconds: #{secs_remaining}"
    if secs_remaining > self.running_duration
      distance += (self.speed * self.running_duration)
    else
      distance += (self.speed * secs_remaining)
    end
    distance
  end
end

class ReindeerRace
  attr_accessor :reindeers, :scores

  def initialize(input="")
    self.reindeers = []
    parse(input)
    self.scores = Hash.new(0)
  end

  def parse(input)
    # http://rubular.com/r/4j8tJGdjzG
    regex = /^(\S+) can fly (\d+) km\/s for (\d+) seconds.*?rest for (\d+) seconds/

    input.each_line do |line|
      next unless match = line.match(regex)
      caps = match.captures
      self.reindeers << Reindeer.new(caps[0], caps[1].to_i, caps[2].to_i, caps[3].to_i)
    end
  end

  def calculate_scores(seconds)
    self.scores = Hash.new(0) # reset

    seconds.times do |secs|
      tmp_deers = {}
      self.reindeers.each do |deer|
        distance = deer.distance_traveled_in(secs+1)
        tmp_deers[distance] ||= []
        tmp_deers[distance] << deer
      end
      top_distance = tmp_deers.keys.sort.reverse.first
      tmp_deers[top_distance].each { |deer| self.scores[deer] += 1 }
    end

    self.scores.each do |deer, score|
      p "#{deer.name} traveled #{deer.distance_traveled_in(seconds)} km => #{score} points"
    end
  end

  def distance_traveled_in(seconds)
    self.reindeers.each do |deer|
      p "#{deer.name} traveled #{deer.distance_traveled_in(seconds)} km"
    end
  end

end

if __FILE__ == $0
  input = ARGV[0]
  seconds = (ARGV[1] || 2503).to_i
  race = ReindeerRace.new(input)
  pp race.reindeers
  p "="*80
  race.calculate_scores(seconds)
end
