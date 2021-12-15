using Formatting
using DataStructures

f = open(joinpath(@__DIR__, "../input/day14.txt"));
#f = open("input/day14_test.txt");


template = collect(readline(f))
readline(f)

rules = Dict()

pairRules= Dict()

while !eof(f)
    line = collect(readline(f))
    rules[(line[1], line[2])] = line[7]
    pairRules[join(line[1:2])] = [join([line[1], line[7]]), join([line[7], line[2]])]
end

function insertionStep(template, rules) 
    result = []
    for (l, r) in zip(template[1:end-1], template[2:end])
        push!(result, l)
        if haskey(rules, (l,r))
            push!(result, rules[(l,r)])
        end
    end
    push!(result, template[end])
    return result
end

function applyn(f, x, n=1)
    for _ in 1:n
        x = f(x)
    end
    return x
end

function insertionStepPairwise(pairCounter, pairRules) 
    afterCounter = Dict()
    for (k,v) in pairCounter
        left, right = pairRules[k]
        if !haskey(afterCounter, left)
            afterCounter[left] = 0
        end
        if !haskey(afterCounter, right)
            afterCounter[right] = 0
        end
        afterCounter[left] += v
        afterCounter[right] += v
    end
    return afterCounter
end

after10 = applyn(x->insertionStep(x, rules), template, 10)
c = counter(after10)
printfmt("\nCharacter Counts: {}", c)
maxDiff = maximum(values(c)) - minimum(values(c))
printfmt("\nMaximum difference: {}", maxDiff)



templatePairs = [join([a,b]) for (a,b) in zip(template[1:end-1], template[2:end])]
printfmt("\ntemplatePairs: {}", templatePairs)
templatePairCounter = counter(templatePairs)
after50pairs = applyn(x->insertionStepPairwise(x, pairRules), templatePairCounter, 40)
printfmt("\nCharacter Counts: {}", after50pairs)

charCount = Dict()
for (k, v) in after50pairs
    a, b = collect(k)

    if !haskey(charCount, a)
        charCount[a] = 0
    end
    if !haskey(charCount, b)
        charCount[b] = 0
    end
    charCount[a] += v
    charCount[b] += v
end
charCount[template[1]] +=1
charCount[template[end]] +=1
charCount = Dict(k=>Int(v/2) for (k,v) in charCount)


printfmt("\ncharCount: {}", charCount)
maxDiff = maximum(values(charCount)) - minimum(values(charCount))
printfmt("\nMaximum difference: {}", maxDiff)
