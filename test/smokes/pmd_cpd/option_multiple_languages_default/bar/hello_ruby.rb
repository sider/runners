def main()
    print_hello()
end

def print_hello()
    puts "Hello, world!"
end

def show_status_tank capacity
    case capacity
    when 0
        "You ran out of gas."
    when 1..20
        "The tank is almost empty. Quickly, find a gas station!"
    when 21..70
        "You should be ok for now."
    when 71..100
        "The tank is almost full."
    else
        "Error: capacity has an invalid value (#{capacity})"
    end
end

main()
