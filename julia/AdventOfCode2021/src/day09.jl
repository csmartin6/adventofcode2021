using Formatting
using Graphs

f = open(joinpath(@__DIR__, "../input/day09.txt"));
lines = readlines(f)
heights = hcat([[parse(Int, n) for n in collect(strip(line))] for line in lines]...)
m, n = size(heights)
aug_heights = hcat(9*ones(Int, m+2, 1), vcat(9*ones(Int,1, n), heights, 9*ones(Int, 1,n)), 9*ones(Int, m+2, 1))


m, n = size(aug_heights)

low_points = []
for i in 2:m-1
    for j in 2:n-1
        if aug_heights[i,j] < minimum([aug_heights[i-1,j], aug_heights[i,j-1], aug_heights[i+1,j], aug_heights[i,j+1]])
            push!(low_points, aug_heights[i,j])
        end
    end
end

printfmt("\n Number of lowpoints: {:d}", length(low_points))
printfmt("\n Sum of lowpoints: {:d}", sum(low_points)+length(low_points))


indicies = [(i,j) for i in 2:m-1 for j in 2:n-1]
nonNines = filter(x-> aug_heights[x[1], x[2]] != 9, indicies)

indMap = Dict((i, x) for (x, i) in enumerate(nonNines))
heightMap = Dict((x, aug_heights[i[1], i[2]]) for (x, i) in enumerate(nonNines))
g = SimpleGraph(length(nonNines));

for ind in nonNines
    i, j = ind
    if aug_heights[i, j] != 9
        if aug_heights[i+1, j] != 9
            add_edge!(g, indMap[(i, j)], indMap[(i+1, j)])
        end
        if aug_heights[i-1, j] != 9
            add_edge!(g, indMap[(i, j)], indMap[(i-1, j)])
        end
        if aug_heights[i, j+1] != 9
            add_edge!(g, indMap[(i, j)], indMap[(i, j+1)])
        end
        if aug_heights[i, j-1] != 9
            add_edge!(g, indMap[(i, j)], indMap[(i, j-1)])
        end
    end   
end


top3 = sort(map(length, connected_components(g)), rev=true)[1:3]

printfmt("\n 3 biggest connected components of lowpoints: {:}", top3)
printfmt("\n product: {:d}", top3[1]*top3[2]*top3[3])
