fabric = Array.new(1000) do
    Array.new(1000) do
        Array(Int32).new
    end
end

input = File.open("input")
claim_regex = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
all_ids = [] of Int32
input.each_line do |line|
    parse_match = claim_regex.match(line)
    next if parse_match.nil?
    id = parse_match[1].to_i
    all_ids << id
    left = parse_match[2].to_i
    top = parse_match[3].to_i
    width = parse_match[4].to_i
    height = parse_match[5].to_i

    (left...(left + width)).each do |l|
        (top...(top + height)).each do |t|
            fabric[l][t] << id
        end
    end
end

square_inches = 0
bad_ids = Set(Int32).new
fabric.each do |i|
    i.each do |j|
        square_inches += 1 if j.size > 1
        bad_ids = bad_ids.concat(j) if j.size > 1
    end
end

good_id = (all_ids - bad_ids.to_a).first

puts "part 1 full: #{square_inches}"
puts "part 2 full: #{good_id}"
