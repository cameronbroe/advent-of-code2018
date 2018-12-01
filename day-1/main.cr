total = 0
memoized_totals = {} of Int32 => Bool
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
    if memoized_totals.has_key?(total)
        repeated_total = total
        repeated_found = true
        break
    else
        memoized_totals[total] = true
    end
    total += freq_change
end
initial_total = total

elapsed_time = Time.measure do
    while !repeated_found
        iteration_count += 1
        freq_changes_memoized.each do |freq_change|
            if memoized_totals.has_key?(total)
                repeated_total = total
                repeated_found = true
                break
            else
                memoized_totals[total] = true
            end
            total += freq_change
        end
    end
end

puts "Total: #{initial_total}"
puts "First Repeated: #{repeated_total}"
puts "Time to compute: #{elapsed_time.milliseconds}"
