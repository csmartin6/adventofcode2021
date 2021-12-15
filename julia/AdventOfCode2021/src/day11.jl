using Formatting

function readDigits()
    f = open(joinpath(@__DIR__, "../input/day11.txt"));
    lines = readlines(f)
    matrix =[[parse(Int,x) for x in split(line, "")] for line in lines]
    return hcat(matrix...)'
end


function updateOctopus(octopuses)
    m,n = size(octopuses)
    newOctopuses = copy(octopuses)
    # add one to everyone
    newOctopuses = newOctopuses .+ 1
    alreadyFlashed = Set()
    needToFlash = Set(findall(newOctopuses.>9))

    while length(needToFlash) > 0
        # flash everyone at once 
        flashes = zeros(Int, size(octopuses)...)
        for toFlash in needToFlash
            i = toFlash[1]
            j = toFlash[2]
            if i > 1 && j > 1
                flashes[i-1, j-1] += 1
            end
            if i > 1 
                flashes[i-1, j] += 1
            end
            if i > 1 && j < n
                flashes[i-1, j+1] += 1
            end
            if j > 1
                flashes[i, j-1] += 1
            end
            if j < n
                flashes[i, j+1] += 1
            end
            if i < m && j > 1
                flashes[i+1, j-1] += 1
            end
            if i < m 
                flashes[i+1, j] += 1
            end
            if i < m && j < n
                flashes[i+1, j+1] += 1
            end
        end
        newOctopuses = newOctopuses + flashes
        alreadyFlashed = union(needToFlash, alreadyFlashed)
        # work out who needs to flash 
        needToFlash = setdiff(findall(newOctopuses.>9), alreadyFlashed)
    end

    
    flashCount = length(alreadyFlashed)
    if flashCount > 0
        for i in alreadyFlashed
            newOctopuses[i] = 0
        end
    end
    return newOctopuses, flashCount
end


function part1(n)
    octopuses = readDigits()
    flashCount = 0
    for _ in 1:n
        octopuses, dailyFlashCount= updateOctopus(octopuses)
        flashCount += dailyFlashCount
    end

    return flashCount
end

# flashCount = part1(100)

# printfmt("\nAfter 100 day: {} flashes", flashCount)

function part2()
    octopuses = readDigits()
    i = 1
    octopuses, flashCount= updateOctopus(octopuses)
    while flashCount != length(octopuses) 
        i +=1 
        octopuses, flashCount= updateOctopus(octopuses)
    end
    return i
end

sync_step = part2()

printfmt("\nFlashes syncronized on step {}", sync_step)
