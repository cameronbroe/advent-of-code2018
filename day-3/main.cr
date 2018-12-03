fabric = Hash(Tuple(Int32, Int32), Int32).new do |hash, key|
    hash[key] = 0
end

fabric_2 = Hash(Tuple(Int32, Int32), Array(Int32)).new do |hash, key|
    hash[key] = Array(Int32).new
end

input = File.open("input")
claim_regex = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
input.each_line do |line|
    parse_match = claim_regex.match(line)
    next if parse_match.nil?
    id = parse_match[1].to_i
    left = parse_match[2].to_i
    top = parse_match[3].to_i
    width = parse_match[4].to_i
    height = parse_match[5].to_i

    (left...(left + width)).each do |l|
        (top...(top + height)).each do |t|
            fabric[{l, t}] += 1
            fabric_2[{l, t}] << id
        end
    end
end

square_inches = fabric.values.count { |x| x > 1 }

dup_ids = {} of Int32 => Bool
fabric_2.values.each do |i|
    i.each { |j| dup_ids[j] ||= false }
    if i.size > 1
        i.each { |j| dup_ids[j] ||= true }
    end
end

no_dup = dup_ids.find { |id, has_dup| has_dup == false }

puts "part 1: #{square_inches}"
puts "part 2: #{no_dup[0]}" unless no_dup.nil?
