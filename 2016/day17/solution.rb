#!/usr/bin/env ruby

require 'digest/md5'

class Grid
    attr_accessor :grid, :location, :passcode, :path, :solutions, :find_longest

    def initialize()
        @grid = Array.new(4) { |i| Array.new(4) }
        @location = [0,0]
        @passcode = 'njfxhljp'
        @path = '' # haven't gone anywhere yet
        @solutions = []
        @find_longest = false
    end

    def navigate(x=0, y=0, current_route='')
        if !find_longest && solutions.count > 0
            # stop if we have a shorter route
            shortest = solutions.min { |a,b| a.length <=> b.length }
            if current_route.length > shortest.length
                puts "@ #{x},#{y} - [#{current_route}] LONGER than #{shortest} - *ABORT*"
                puts
                return
            end
        end

        # have we reached the vault?
        if x == 3 && y == 3
            draw
            puts "@ #{x},#{y} - [#{current_route}] *SOLUTION*"
            puts

            solutions << current_route
            return
        end

        @path = current_route
        @location = [x, y]

        options = current_options
        options_text = options.collect { |o| direction_text(o) }.join(',')

        draw
        puts "@ #{x},#{y} - [#{current_route}] Options: #{options_text}"
        puts

        options.each do |direction|
            case direction
            when :up
                navigate(x, y - 1, current_route + 'U')
            when :down
                navigate(x, y + 1, current_route + 'D')
            when :left
                navigate(x - 1, y, current_route + 'L')
            when :right
                navigate(x + 1, y, current_route + 'R')
            end
        end
    end

    def current_options
        x = location[0]
        y = location[1]

        [:up, :down, :left, :right].collect do |dir|
            door_unlocked?(x, y, dir) ? dir : nil
        end.compact
    end

    def valid_coordinates?(x, y)
        (0..3).include?(x) && (0..3).include?(y)
    end

    def location_hash
        return Digest::MD5.hexdigest(@passcode + @path).downcase[0,4]
    end

    def unlocked?(direction)
        hash = location_hash

        code = \
        case direction
        when :up
            hash[0]
        when :down
            hash[1]
        when :left
            hash[2]
        when :right
            hash[3]
        else
            "X"
        end

        ("b".."f").include?(code.downcase)
    end

    def flip_direction(direction)
        case direction
        when :up
            :down
        when :down
            :up
        when :left
            :right
        when :right
            :left
        end
    end

    def direction_text(direction)
        case direction
        when :up
            "up"
        when :down
            "down"
        when :left
            "left"
        when :right
            "right"
        end
    end

    def door_unlocked?(x, y, direction)
        to_x = -1
        to_y = -1

        case direction
        when :up
            to_x = x
            to_y = y - 1
        when :down
            to_x = x
            to_y = y + 1
        when :left
            to_x = x - 1
            to_y = y
        when :right
            to_x = x + 1
            to_y = y
        else
            puts "HUH?!?"
        end

        # need valid coordinates to and from
        if !( valid_coordinates?(x,y) && valid_coordinates?(to_x, to_y) )
            return false
        end

        # with current location, direction matches
        if location[0] == x && location[1] == y
            # puts "(*) #{x},#{y} -> #{to_x},#{to_y} #{direction_text}"
            return unlocked?(direction)
        end

        # when moving to current location, direction is reverse
        if location[0] == to_x && location[1] == to_y
            # puts "#{x},#{y} -> (*) #{to_x},#{to_y} #{direction_text}"
            new_direction = flip_direction(direction)
            return unlocked?(new_direction)
        end

        false
    end

    def draw
        output = '#'*9 + "\n"
        4.times do |y|
            row_str = '#'
            row_border_str = '#'
            4.times do |x|
                # p "#{x},#{y}"
                if @location[0] == x && @location[1] == y
                    row_str += 'S'
                else
                    row_str += ' '
                end

                if door_unlocked?(x,y, :down)
                    row_border_str += 'o'
                else
                    row_border_str += '-'
                end
                row_border_str += '#' unless x == 3

                if x != 3
                    if door_unlocked?(x,y, :right)
                        row_str += "o"
                    else
                        row_str += "|"
                    end
                end

            end
            row_str += '#' + "\n"
            row_border_str += '#' + "\n"
            output += row_str
            output += row_border_str unless y == 3
        end
        output += '#'*8 + "V" + "\n"
        puts output
    end
end

grid = Grid.new
# grid.find_longest = true
grid.navigate

puts "Solutions:"
grid.solutions.sort { |a,b| a.length <=> b.length }.each do |solution|
    puts "#{solution} (#{solution.length})"
end
