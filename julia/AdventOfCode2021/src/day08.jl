using Combinatorics
using Formatting


wires = ["a", "b", "c", "d","e","f", "g"]
wires2digit = Dict(
    "abcefg"=>0, 
    "cf" => 1, 
    "acdeg" => 2, 
    "acdfg" => 3, 
    "bcdf" => 4,
    "abdfg" => 5,
    "abdefg" => 6,
    "acf" => 7,
    "abcdefg" => 8,
    "abcdfg" => 9)

digit2wires =  Dict( (value, key) for (key, value) in wires2digit)


function sortString(s)
    return join(sort(collect(s)))
end

function getLetterChanges(wires, perm)
    return Dict((only(wires[i]), only(wires[perm[i]])) for i in 1:length(perm))
end

function permuteWires(str, perm, wires)
    letterChange = getLetterChanges(wires, perm)
    return join(sort([letterChange[s] for s in collect(str)]))
end


perm = permutations(1:7)
permDict= Dict([(Set([permuteWires(k, p, wires) for (k,v) in wires2digit]), p) for p in perm])

function getDigits(leftSide, rightSide, permDict)
    pattern = Set([sortString(x) for x in split(leftSide, " ")])
    rightDigits = split(rightSide, " ")
    linePerm = permDict[pattern]
    return [wires2digit[permuteWires(r, invperm(linePerm), wires)] for r in rightDigits]
end


f = open(joinpath(@__DIR__, "../input/day08.txt"));
signals = [collect(split(line, " | ")) for line in readlines(f)]


digitsInSignals = [getDigits(s[1], s[2], permDict) for s in signals]

c = count(s-> s in [1, 4, 7, 8], hcat(digitsInSignals...))
printfmt("\n{:d} 1, 4, 7, 8 's", c)


digitsInSignals = [getDigits(s[1], s[2], permDict) for s in signals]

code = sum([evalpoly(10, reverse(d)) for d in digitsInSignals])
printfmt("\nsum {:d}", code)
