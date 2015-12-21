#!/usr/bin/env ruby

require_relative "day9"

planner = SantaRoutePlanner.new
planner.read_map(
"London to Dublin = 464
 London to Belfast = 518
 Dublin to Belfast = 141")

pp planner.locations
pp planner.location_map
planner.find_routes
p '='*80
planner.print_routes
p '='*80
pp shortest = planner.shortest_route
pp longest = planner.longest_route
# pp "SHORTEST ROUTE: #{shortest.total_distance}"
