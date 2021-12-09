using Formatting

f = open(joinpath(@__DIR__, "../input/day05.txt"));
rows = readlines(f)

lines = []
for row in rows
    startPair, endPair = split(row, "->")
    startPoint = [parse(Int, n) for n in split(strip(startPair),",")]
    endPoint = [parse(Int, n) for n in split(strip(endPair),",")]

    push!(lines, (startPoint=startPoint, endPoint=endPoint))
end

function part1()
    maxX = maximum([maximum([line.startPoint[1],line.endPoint[1]]) for line in lines])
    maxY = maximum([maximum([line.startPoint[2],line.endPoint[2]]) for line in lines])
    counts = zeros(Int, maxX+1, maxY+1)
    for line in lines
        if line.startPoint[1] == line.endPoint[1]
            # vertical line
            j = line.startPoint[1]
            step = line.startPoint[2] < line.endPoint[2] ? 1 : -1
            for i in line.startPoint[2]: step : line.endPoint[2]
                counts[i+1, j+1] += 1
            end
        elseif line.startPoint[2] == line.endPoint[2]
            # horizontal line
            i = line.startPoint[2]
            step = line.startPoint[1] < line.endPoint[1] ? 1 : -1
            for j in line.startPoint[1]: step : line.endPoint[1]
                counts[i+1, j+1] += 1
            end
        end
    end
    crossings = length(counts[counts.>1])
    return crossings
end
printfmt("\nPart1 crossings: {:d}\n", part1())
function part2()
    maxX = maximum([maximum([line.startPoint[1],line.endPoint[1]]) for line in lines])
    maxY = maximum([maximum([line.startPoint[2],line.endPoint[2]]) for line in lines])
    counts = zeros(Int, maxX+1, maxY+1)
    for line in lines
        if line.startPoint[1] == line.endPoint[1]
            # vertical line
            j = line.startPoint[1]
            step = line.startPoint[2] < line.endPoint[2] ? 1 : -1
            for i in line.startPoint[2]: step : line.endPoint[2]
                counts[i+1, j+1] += 1
            end
        elseif line.startPoint[2] == line.endPoint[2]
            # horizontal line
            i = line.startPoint[2]
            step = line.startPoint[1] < line.endPoint[1] ? 1 : -1
            for j in line.startPoint[1]: step : line.endPoint[1]
                counts[i+1, j+1] += 1
            end
        else 
            # diagonal lines
            stepX = line.startPoint[1] < line.endPoint[1] ? 1 : -1
            stepY = line.startPoint[2] < line.endPoint[2] ? 1 : -1
            lineLength = abs(line.startPoint[1]-line.endPoint[1])
            for i in 1:(lineLength+1)
                counts[line.startPoint[2]+(i-1)*stepY+1, line.startPoint[1]+(i-1)*stepX+1] += 1
            end
        end

    end
    crossings = length(counts[counts.>1])
    return crossings
end
printfmt("\nPart2 crossings: {:d}\n", part2())
