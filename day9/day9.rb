#!/usr/bin/env ruby

require "pp"

class SantaRoute
  attr_accessor :locations, :distances

  def initialize(visited_locations)
    self.locations = [visited_locations].flatten
    self.distances = []
  end

  def push(location, distance)
    self.locations << location
    self.distances << distance
  end

  def last_location
    self.locations.last
  end

  def has_visited?(location)
    self.locations.include?(location)
  end

  def total_distance
    self.distances.inject(0) { |sum, dist| sum + dist }
  end

  def print
    p self.locations.join(" -> ") + " = #{total_distance}"
  end

  def ==(another_route)
    self.locations == another_route.locations ||
    self.locations == another_route.locations.reverse
  end
end

class SantaRoutePlanner
  attr_accessor :location_map, :locations

  def initialize
    self.location_map = {}
    self.locations = []
  end

  def read_map(input)
    input.each_line do |line|
      # http://rubular.com/r/8xYpj5Gvg4
      if match = line.strip.match(/(\S+) to (\S+) = (\d+)/)
        origin = match.captures[0]
        dest   = match.captures[1]
        distance = match.captures[2].to_i

        add_location(origin)
        add_location(dest)

        self.location_map[origin] ||= {}
        self.location_map[origin][dest] = distance

        self.location_map[dest] ||= {}
        self.location_map[dest][origin] = distance
      else
        p "Did not understand '#{line}'"
      end
    end
  end

  def find_routes
    self.locations.collect do |loc|
      p "Routes from #{loc}"
      routes_from(SantaRoute.new(loc))
    end.flatten
  end

  def shortest_of_routes(routes)
    routes.sort_by!(&:total_distance).first
  end

  def routes_from(route)
    route.print

    routes = []
    next_locations = self.location_map[route.last_location].keys
    p "Destinations from #{route.last_location}: #{next_locations.sort}"
    next_locations.each do |next_location|
      distance = (self.location_map[route.last_location][next_location] || 0)
      p "XXX #{route.last_location} -> #{next_location} (#{distance})"
      if route.has_visited?(next_location)
        routes << route
      else
        r = route.clone
        r.push(next_location, distance)
        routes << routes_from(r)
      end
    end
    prune_incomplete_routes((routes.flatten || []).compact)
  end

  def prune_incomplete_routes(routes)
    routes.find_all { |r| r.locations.count == self.locations.count }
  end

  def add_location(loc)
    self.locations << loc unless self.locations.include?(loc)
  end
end

if __FILE__ == $0
  input = ARGV[0]
  planner = SantaRoutePlanner.new
  planner.read_map(input)

  pp planner.locations
  pp planner.location_map
  p '='*80
  routes = planner.find_routes
  p '='*80
  # pp shortest = planner.shortest_of_routes(routes)
  # pp "SHORTEST ROUTE: #{shortest.total_distance}"

end
