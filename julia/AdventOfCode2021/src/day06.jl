using Formatting


function simulate_day(school)
    # timer: [0, 1, 2, 3, 4, 5, 6, 7, 8]]
    return [school[2], school[3], school[4], school[5], school[6], school[7], school[8]+school[1], school[9], school[1]]
end


test_fishes = [3, 4, 3 ,1 ,2]

function makeschool(fishes)
    school = zeros(9)
    for fish in fishes
        school[fish+1]+=1
    end
    return school
end


function simulate(school, days)
    current_school = school
    for _ in 1:days
        current_school = simulate_day(current_school)
    end
    return current_school
end

function getFishes()
    f = open(joinpath(@__DIR__, "../input/day06.txt"));
    fishes = [parse(Int,n) for n in split(readline(f), ",")]
    return fishes  
end

function part1()
    fishes = getFishes()
    school = makeschool(fishes)
    schoolAfter80 = simulate(school, 80)
    return schoolAfter80    
end

printfmt("\n{:d} fishes after 80 days", sum(part1()))


function part2()
    fishes = getFishes()
    school = makeschool(fishes)
    schoolAfter256 = simulate(school, 256)
    return schoolAfter256    
end

printfmt("\n{:d} fishes after 256 days", sum(part2()))
