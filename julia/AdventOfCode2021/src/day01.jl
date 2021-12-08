using Formatting

function readNumbers()
    f = open(joinpath(@__DIR__, "../input/day01.txt"));
    lines = readlines(f)
    numbers = map(x -> parse(Int, x), lines)
    return numbers
end

function countIncreases(array)
    diffs = array[2:end] - array[1:end-1]
    increases = count(x -> x > 0, diffs)
    return increases
end


function part1()
    numbers = readNumbers()
    increases = countIncreases(numbers)
    printfmt("{:d} increases", increases)
end

function part2()
    numbers = readNumbers()
    rollingWindow = [numbers[3:end] numbers[2:end-1] numbers[1:end-2]]
    rollingSum = sum(rollingWindow, dims=2)
    increases = countIncreases(rollingSum)
    printfmt("{:d} increases", increases)
end

part2()
