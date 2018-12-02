exactly_two = 0
exactly_three = 0

def has_two(line)
    as_array = line.split("")
    available_chars(line).each do |c|
        if as_array.count(c) == 2
            return true
        end
    end
    false
end

def has_three(line)
    as_array = line.split("")
    available_chars(line).each do |c|
        if as_array.count(c) == 3
            return true
        end
    end
    false
end

def available_chars(line)
    line.split("").uniq
end

def id_diff(line_a, line_b)
    line_a_split = line_a.split("")
    line_b_split = line_b.split("")
    return nil if line_a_split.size != line_b_split.size
    diff_count = 0
    diff_indices = [] of Int32
    line_a_split.each_index do |ind|
        if line_a_split[ind] != line_b_split[ind]
            diff_count += 1
            diff_indices << ind
        end
    end
    if diff_count == 1
        diff_string = ""
        line_a_split.each_index do |ind|
            diff_string += line_a_split[ind] unless diff_indices.includes? ind
        end
        return diff_string
    end
    nil
end

memoized_input = [] of String

input = File.open("input")
input.each_line do |line|
    exactly_two += 1 if has_two(line)
    exactly_three += 1 if has_three(line)
    memoized_input << line
end

puts "checksum: #{exactly_two * exactly_three}"


found = false
memoized_input.each do |line|
    memoized_input.each do |line2|
        is_answer = id_diff(line, line2)
        unless is_answer.nil?
            puts "part 2: #{is_answer}"
            found = true
            break
        end
    end
    break if found
end
