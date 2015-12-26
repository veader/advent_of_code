#!/usr/bin/env ruby

require_relative "day14"

data = "Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."

race = ReindeerRace.new(data)
pp race.reindeers
race.distance_traveled_in(1000)
