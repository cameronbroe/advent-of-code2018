class Guard
    def initialize(id : Int32)
        @id = id
        @events = [] of Event
    end

    def id
        @id
    end

    def add_event(event : Event)
        @events << event
    end

    def time_asleep
        time_asleep = 0
        asleep = false
        asleep_time = nil
        @events.each do |event|
            if event.type == EventType::Sleep
                asleep = true
                asleep_time = event.time
            elsif event.type == EventType::Wake
                if asleep
                    asleep = false
                    time_diff = event.time - asleep_time unless asleep_time.nil?
                    time_asleep += time_diff.to_i unless time_diff.nil?
                end
            end
        end
        time_asleep
    end

    def minutes_asleep
        minutes_asleep = {} of Int32 => Int32
        (0...60).each { |m| minutes_asleep[m] ||= 0 }
        asleep = false
        asleep_time = nil
        @events.each do |event|
            if event.type == EventType::Sleep
                asleep = true
                asleep_time = event.time
            elsif event.type == EventType::Wake
                if asleep
                    asleep = false
                    unless asleep_time.nil?
                        (asleep_time.minute...event.time.minute).each do |minute|
                            minutes_asleep[minute] += 1
                        end
                    end
                end
            end
        end
        minutes_asleep
    end
end

class Event
    def initialize(time : String, type : EventType)
        @time = Time.parse_utc(time, "%Y-%m-%d %H:%M")
        @type = type
    end

    def time
        @time
    end

    def type
        @type
    end
end

enum EventType
    ShiftStart
    Sleep
    Wake
end

input = File.open("input")
input_memoized = [] of String
input.each_line do |line|
    input_memoized << line
end
input_memoized.sort!

guards = {} of Int32 => Guard

last_guard_id = 0
input_memoized.each do |line|
    parse_initial = /^\[(.+?)\] (.+?)$/
    parse_match = parse_initial.match(line)
    next if parse_match.nil?
    time = parse_match[1]

    type_str = parse_match[2]
    event_type = nil
    if type_str == "falls asleep"
        event_type = EventType::Sleep
    elsif type_str == "wakes up"
        event_type = EventType::Wake
    else
        event_type = EventType::ShiftStart
        guard_id_regex = /^Guard #(\d+) begins shift$/
        guard_id_match = guard_id_regex.match(type_str)
        next if guard_id_match.nil?
        last_guard_id = guard_id_match[1].to_i
    end

    # Add a guard to map if doesn't exist
    guards[last_guard_id] ||= Guard.new(last_guard_id)
    
    # Construct event object and add to guard
    event = Event.new(time, event_type)
    guards[last_guard_id].add_event(event)
end

max_guard = nil
guards.each do |guard_id, guard|
    max_guard ||= guard
    max_guard = guard if guard.time_asleep > max_guard.time_asleep
end

sleepy_minutes = {} of Int32 => Array(Tuple(Int32, Int32))
(0...60).each do |minute|
    guards.each do |guard_id, guard|
        minutes_asleep = guard.minutes_asleep
        sleepy_minutes[minute] ||= [] of Tuple(Int32, Int32)
        sleepy_minutes[minute] << {guard_id, minutes_asleep[minute]}
    end
end

max_sleepy_minutes = {} of Int32 => Tuple(Int32, Int32)
sleepy_minutes.each do |minute, guard_times|
    max_guard_time = guard_times.max_by { |g| g[1] }
    max_sleepy_minutes[minute] = max_guard_time
end

unless max_guard.nil?
    max_minute = max_guard.minutes_asleep.max_by { |g| g[1] }[0]
    puts "part 1: #{max_guard.id * max_minute}" unless max_minute.nil?


    part_2_max = max_sleepy_minutes.max_by { |g| g[1][1] }
    puts "part 2: #{part_2_max[1][0] * part_2_max[0]}"
end
