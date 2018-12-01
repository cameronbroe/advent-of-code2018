total = 0
memoized_totals = [] of Int32
repeated_total = 0
repeated_found = false
initial_total = 0

def parse_frequency_change(frequency_change)
    match_data = /^(\+|\-)(\d+)$/.match(frequency_change)
    return 0 if match_data.nil?
    pos_or_neg = match_data[1]
    number = match_data[2].to_i
    return number if pos_or_neg == "+"
    return (-1 * number) if pos_or_neg == "-"
    0
end

iteration_count = 1

input = File.open("input")
freq_changes_memoized = [] of Int32
input.each_line do |line|
    freq_change = parse_frequency_change(line)
    freq_changes_memoized << freq_change
    memoized_totals << total
    if memoized_totals.count(total) > 1
        repeated_found = true
        repeated_total = total
        break
    end
    total += freq_change
end
initial_total = total

while !repeated_found
    iteration_count += 1
    freq_changes_memoized.each do |freq_change|
        memoized_totals << total
        if memoized_totals.count(total) > 1
            repeated_found = true
            repeated_total = total
            break
        end
        total += freq_change
    end
end

puts "Total: #{initial_total}"
puts "First Repeated: #{repeated_total}"
