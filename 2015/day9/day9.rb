#!/usr/bin/env ruby

require "pp"

class SantaRoutePlanner
  attr_accessor :location_map, :locations, :routes, :distances

  def initialize
    self.location_map = {}
    self.locations = []
    self.routes = []
    self.distances = {}
    @distances_calulated = false
  end

  # ------------------------------------------------------
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

  def add_location(loc)
    self.locations << loc unless self.locations.include?(loc)
  end

  # ------------------------------------------------------
  def find_routes
    self.locations.each do |loc|
      p "Routes from #{loc}"
      routes_from([loc])
    end
  end

  def calculate_distances
    return if @distances_calulated
    self.routes.each { |r| self.distances[distance_for_route(r)] = r }
    @distances_calulated = true
  end

  def distance_for_route(route)
    distance = 0
    last = nil
    route.each do |loc|
      if last.nil?
        last = loc
        next
      else
        distance += self.location_map[last][loc]
        last = loc
      end
    end
    distance
  end

  def routes_from(route)
    print_route(route)

    last_location  = route.last
    return if self.location_map[last_location].nil?
    next_locations = self.location_map[last_location].keys

    next_locations.each do |next_location|
      if route.include?(next_location) # don't loop
        if route_complete?(route) # save this route if we hit all locations
          self.routes << route unless self.routes.include?(route)
        end
      else
        routes_from(route + [next_location])
      end
    end
  end

  def route_complete?(route)
    route.uniq.count == self.locations.count
  end

  def shortest_route
    calculate_distances
    p "SHORTEST:"
    short = distances.keys.sort.first
    print_route(self.distances[short])
  end

  def longest_route
    calculate_distances
    p "LONGEST:"
    long = distances.keys.sort.last
    print_route(self.distances[long])
  end

  def print_route(route)
    return if route.nil?
    p "#{route.join(' -> ')} = #{distance_for_route(route)}"
  end

  def print_routes
    p "#{self.routes.count} Routes Found"
    self.routes.map { |r| print_route(r) }
  end
end

if __FILE__ == $0
  input = ARGV[0]
  planner = SantaRoutePlanner.new
  planner.read_map(input)

  pp planner.locations
  pp planner.location_map
  planner.find_routes
  p '='*80
  planner.print_routes
  p '='*80
  pp planner.shortest_route
  p '='*80
  pp planner.longest_route

end
