using Formatting

function parseLine(line) 
    direction, magnitude = split(line, " ")
    return (direction=direction, magnitude=parse(Int, magnitude))
end

function readCommands()
    f = open("input/day02.txt");
    lines = readlines(f)
    commands = map(line -> parseLine(line), lines)
    return commands
end

function part1() 
    commands = readCommands()

    depth = 0
    x = 0

    for command in commands
        if command.direction == "forward"
            x += command.magnitude
        elseif command.direction == "up"
            depth -= command.magnitude
        elseif command.direction == "down"
            depth += command.magnitude
        end
    end
    return depth, x
end


function part2() 
    commands = readCommands()

    depth = 0
    x = 0
    aim = 0

    for command in commands
        if command.direction == "forward"
            x += command.magnitude
            depth += aim * command.magnitude
        elseif command.direction == "up"
            aim -= command.magnitude
        elseif command.direction == "down"
            aim += command.magnitude
        end
    end
    return depth, x
end

depth,x = part2() 

printfmt("depth: {:d} \nhorizontal: {:d}", depth, x)

printfmt("\nproduct: {:d}", depth * x)
