using Formatting
using Graphs
using SparseArrays

function readRisks()
    f = open(joinpath(@__DIR__, "../input/day15.txt"));
    lines = readlines(f)
    matrix =[[parse(Int,x) for x in split(line, "")] for line in lines]
    return hcat(matrix...)'
end

function leastRiskyPath(risks)
    m, n = size(risks)
    if m == 1 && n == 1
        return risks[1,1]
    end
    
    if m == 1
        return risks[1,1] + leastRiskyPath(risks[:, 2:end])
    elseif n ==1 
        return risks[1,1] + leastRiskyPath(risks[2:end, :])
    else
        return risks[1,1] + min(leastRiskyPath(risks[:, 2:end]),leastRiskyPath(risks[2:end, :]))
    end
end


function leastRiskyPathIJ(risks)
    m, n = size(risks)

    least_risk = zeros(Int, size(risks))
    least_risk[m,n] = risks[m,n]
    for i = m:-1:1
        for j = n:-1:1
            down = i != m ? least_risk[i+1, j] : typemax(Int)
            right = j != n ? least_risk[i, j+1] : typemax(Int)
            if i == m && j == m
                least_risk[i,j] = risks[i,j]
            else 
                least_risk[i,j] = min(down, right) + risks[i,j]
            end
        end
    end 
    return least_risk[1,1]
end


risks = readRisks()
leastRisk = leastRiskyPathIJ(risks) - risks[1,1]
printfmt("\nleastRisk: {}", leastRisk)

function cycleNumber(n, base = 9)
    return mod(n-1, base) + 1
end

function tileCave(original, m, n)
    rows = []
    for i in 1:m
        row = hcat([original .+ j for j in (i-1):((i-1)+n-1)]...)
        push!(rows, row)
    end
    mat = vcat(rows...)
    return cycleNumber.(mat)
end

# fullcave = tileCave(risks, 5, 5)
# leastRiskfullcave = leastRiskyPathIJ(fullcave) - fullcave[1,1]
# printfmt("\nleastRiskfullcave: {}", leastRiskfullcave)


function leastRiskyPathGraph(risks)
    m, n = size(risks)

    g = SimpleDiGraph(m*n)
    rows::Vector{Int} = []
    cols::Vector{Int} = []
    values::Vector{Int} = [] 
    for i in 1:m
        for j in 1:n 
            ind = j + n * (i-1)
            if j < n
                # right
                ind_right = ind + 1
                add_edge!(g, ind, ind_right)
                push!(rows, ind)
                push!(cols, ind_right)
                push!(values, risks[i,j+1])
            end
            if j > 1
                # left
                ind_left = ind - 1
                add_edge!(g, ind, ind_left)
                push!(rows, ind)
                push!(cols, ind_left)
                push!(values, risks[i,j-1])
            end
            if i < m
                # down
                ind_down = ind + n
                add_edge!(g, ind, ind_down)
                push!(rows, ind)
                push!(cols, ind_down)
                push!(values, risks[i+1,j])
            end
            if i > 1
                # up
                ind_up = ind - n
                add_edge!(g, ind, ind_up)
                push!(rows, ind)
                push!(cols, ind_up)
                push!(values, risks[i-1,j])
            end

        end
    end
    distmx = sparse(rows, cols, values)
    shortest = a_star(g, 1, m*n, distmx)
    a_star_shortest = sum([distmx[s.src, s.dst] for s in shortest])
    return a_star_shortest
    # return dijkstra_shortest_paths(g, 1, distmx).dists[m*n]
end

risks = readRisks()
leastRiskGraph = leastRiskyPathGraph(risks)
printfmt("\nleastRiskGraph: {}", leastRiskGraph)
fullcave = tileCave(risks, 5, 5)
leastRiskfullcave = leastRiskyPathGraph(fullcave)
printfmt("\nleastRiskfullcave: {}", leastRiskfullcave)
