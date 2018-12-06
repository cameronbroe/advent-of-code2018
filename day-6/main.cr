class Coord
    def initialize(x : Int32, y : Int32)
        @x_coord = x
        @y_coord = y
        @area = 1
        @infinite = false
    end

    def x_coord; @x_coord; end
    def y_coord; @y_coord; end

    def distance_to(x, y)
        (@x_coord - x).abs + (@y_coord - y).abs
    end

    def increment_area!
        @area += 1
    end

    def total_area; @area; end

    def infinite?; @infinite; end

    def infinite!; @infinite = true; end
end

coords = [] of Coord

minimum_x = 999999
maximum_x = 0

minimum_y = 999999
maximum_y = 0

input = File.open("input")
input.each_line do |line|
    line_split = line.split(", ")
    coord_x = line_split[0].to_i
    coord_y = line_split[1].to_i
    
    minimum_x = Math.min(minimum_x, coord_x)
    maximum_x = Math.max(maximum_x, coord_x)

    minimum_y = Math.min(minimum_y, coord_y)
    maximum_y = Math.max(maximum_y, coord_y)

    coord_obj = Coord.new(coord_x, coord_y)
    coords << coord_obj
end

part_2_region_size = 0

(0...500).each do |x|
    (0...500).each do |y|
        coord_distances = coords.map do |coord|
            {coord.distance_to(x, y), coord}
        end

        # Part 2, calculate sum of distances
        distance_sum = 0
        coord_distances.each { |c| distance_sum += c[0] }
        part_2_region_size += 1 if distance_sum < 10000

        coord_distances.sort! { |a, b| a[0] <=> b[0] }
        # If min is zero...then we're on a coord
        if coord_distances[0][0] == 0
            next
        end

        # If the first two elements are equal...then none are closer
        if coord_distances[0][0] == coord_distances[1][0]
            next
        end


        # Otherwise...detect if it'll have an infinite area
        if x < minimum_x || x > maximum_x || y < minimum_y || y > maximum_y
            coord_distances[0][1].infinite!
            next
        end

        coord_distances[0][1].increment_area!
    end
end

# Get maximum area
coord_areas = coords.map { |coord| coord.infinite? ? -1 : coord.total_area }
# puts coord_areas
puts "part 1: #{coord_areas.max}"
puts "part 2: #{part_2_region_size}"
