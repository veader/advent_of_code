#!/usr/bin/env ruby

require_relative "day9"

planner = SantaRoutePlanner.new
planner.read_map(
"London to Dublin = 464
 London to Belfast = 518
 Dublin to Belfast = 141")

pp planner.locations
pp planner.location_map
pp planner.routes_from(SantaRoute.new(planner.locations.first))
# pp routes = planner.find_routes
# pp shortest = planner.shortest_of_routes(routes)
# pp "SHORTEST ROUTE: #{shortest.total_distance}"
