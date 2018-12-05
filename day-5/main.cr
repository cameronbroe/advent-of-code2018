input = File.open("input")
polymer = input.gets_to_end.chomp
input.close
polymer_arr = polymer.chars

def polymer_destruction(polymer)
    polymer_copy = polymer.dup
    loop do
        broke = false
        curr_index = 0
        polymer_copy.each_cons(2) do |cons|
            if (cons[0] - cons[1]).to_i.abs == 32 # Fancy logic to check that they are the same letters, but opposite cases
                polymer_copy.delete_at(curr_index, 2)
                broke = true
                break
            end
            curr_index += 1
        end
        break unless broke
    end
    polymer_copy
end

puts "part 1: #{polymer_destruction(polymer_arr).size}"

part_2_sizes = [] of Int32
('a'..'z').each do |char|
    spawn do
        scrubbed_polymer = polymer.gsub({char.downcase => "", char.upcase => ""})
        scrubbed_polymer_arr = scrubbed_polymer.chars
        part_2_sizes << polymer_destruction(scrubbed_polymer_arr).size
    end
end

Fiber.yield

puts "part 2: #{part_2_sizes.min}"
