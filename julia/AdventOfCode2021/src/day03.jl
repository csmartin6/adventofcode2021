using Formatting

function readDigits()
    f = open(joinpath(@__DIR__, "../input/day03.txt"));
    lines = readlines(f)
    matrix =[[parse(Int,x) for x in split(line, "")] for line in lines]
    return hcat(matrix...)'
end

function part1()
    digitsMat = readDigits()

    N = size(digitsMat)[1]
    gammaBits = map(x-> x > N/2 ? "1" : "0", sum(digitsMat; dims=1))
    gamma = parse(Int, join(gammaBits); base=2)
    epsilonBits = map(x-> x < N/2 ? "1" : "0", sum(digitsMat; dims=1))
    epsilon = parse(Int, join(epsilonBits); base=2)

    return gamma, epsilon
end

# gamma, epsilon = part1() 

# printfmt("\ngamma: {:d}\n", gamma) 
# printfmt("\nepsilon: {:d}\n", epsilon) 
# printfmt("\nproduct: {:d}\n", gamma * epsilon)

function testDigits() 

    return [[0 0 1 0 0]
    [1 1 1 1 0]
    [1 0 1 1 0]
    [1 0 1 1 1]
    [1 0 1 0 1]
    [0 1 1 1 1]
    [0 0 1 1 1]
    [1 1 1 0 0]
    [1 0 0 0 0]
    [1 1 0 0 1]
    [0 0 0 1 0]
    [0 1 0 1 0]]
end


function part2()
    digitsMat = readDigits()

    N = size(digitsMat)[1]

    currDigits = digitsMat[:,:]
    # while size(currDigits)[1] > 1
    #     commonLeadingBit = sum(currDigits[:,1]) > size(currDigits)[1] ? 1 : 0  
    #     currDigits = currDigits[currDigits[:,1].== commonLeadingBit, 2:end]
    # end 
    # oxygen = evalpoly(2,currDigits[1,:])

    currDigits = copy(digitsMat)
    M = size(currDigits)[2]
    i = 1
    N = size(digitsMat)[1]
    while N > 1 && i <=  M
        N = size(currDigits)[1]
        sumOfIthDigit = sum(currDigits[:,i])
        commonBit = sumOfIthDigit >= N/2 ? 1 : 0  
        currDigits = currDigits[currDigits[:,i].== commonBit, :]
        i+=1
        N = size(currDigits)[1]
    end
    oxygen = evalpoly(2,reverse(currDigits[1,:]))



    aDigits = copy(digitsMat)
    i = 1
    N = size(aDigits)[1]
    while N > 1 && i <=  M
        N = size(aDigits)[1]
        sumOfIthDigit = sum(aDigits[:,i])
        uncommonBit = sumOfIthDigit >= N/2 ? 0 : 1  
        aDigits = aDigits[aDigits[:,i].== uncommonBit, :]
        i+=1
        N = size(aDigits)[1]
    end
    co2 = evalpoly(2,reverse(aDigits[1,:]))

    return oxygen, co2
end

oxygen, co2 = part2() 

printfmt("\noxygen: {:d}\n", oxygen) 
printfmt("\nco2: {:d}\n", co2) 
printfmt("\nproduct: {:d}\n", oxygen * co2)
