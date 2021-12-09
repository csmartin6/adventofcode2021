using Formatting
using Statistics

function getCrabs()
    f = open(joinpath(@__DIR__, "../input/day07.txt"));
    crabs = [parse(Int,n) for n in split(readline(f), ",")]
    return crabs  
end

function part1()
    crabs = getCrabs()
    best_location = median(crabs)

    fuel = sum([abs(crab-best_location) for crab in crabs])

    return best_location, fuel
end

location, fuel = part1()
printfmt("\nPart 1: location: {:d} fuel: {:d}", location, fuel)


function part2()
    crabs = getCrabs()
    best_location_up = Int(ceil(mean(crabs)))
    best_location_down = Int(floor(mean(crabs)))
    fuel_up = sum([((crab-best_location_up)^2 + abs(crab-best_location_up))/2  for crab in crabs])
    fuel_down = sum([((crab-best_location_down)^2 + abs(crab-best_location_down))/2  for crab in crabs])

    return fuel_down < fuel_up ? (best_location_down, fuel_down) : (best_location_up, fuel_up)
end
location, fuel = part2()
printfmt("\nPart 2: location: {:d} fuel: {:d}", location, fuel)
