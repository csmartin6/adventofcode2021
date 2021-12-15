using Formatting
using Graphs, MetaGraphs

f = open(joinpath(@__DIR__, "../input/day12.txt"));
# f = open("input/day12_test_C.txt");
lines = readlines(f)
verts = Set()
for l in lines
    for v in split(l,"-")
        push!(verts,v)
    end
end

vertsA = sort(collect(verts))

vMap = Dict((i, v) for (v, i) in enumerate(vertsA))

g = MetaGraph(length(vertsA))
set_prop!(g, :smallCaveTwice, false)
for i in 1:length(vertsA)
    set_prop!(g, i, :name, vertsA[i])
    set_prop!(g, i, :visited, 0)
end
set_indexing_prop!(g, :name)
for line in lines
    source, dest = split(line,"-")
    add_edge!(g, vMap[source], vMap[dest])
end

function isBigCave(graph, vertex)
    name = get_prop(graph, vertex, :name)
    return all([isuppercase(c) for c in collect(name)])
end

function isTerminal(graph, vertex)
    name = get_prop(graph, vertex, :name)
    return name == "start" || name =="end"
end

function canVisitAgain(graph, vertex)
    if isTerminal(graph, vertex) 
        return false
    end
    if isBigCave(graph, vertex) 
        return true
    end 
    smallCaveVisitedTwice = get_prop(graph, :smallCaveTwice)
    maxVisits = smallCaveVisitedTwice ? 1 : 2
    return get_prop(graph, vertex, :visited) < maxVisits
end

# find start

function num_paths(g, v)
    remaining_names = [get_prop(g, u, :name) for u in vertices(g)]
    name = get_prop(g, v, :name)
    if name == "end"
        return 1
    end
    sg = copy(g)

    if !isBigCave(sg, v) #|| length(collect(neighbors(sg, v))) == 1
        rem_vertex!(sg, v)
    end
    return sum([num_paths(copy(sg), sg[get_prop(g, u, :name), :name]) for u in neighbors(g,v)])
end

start_vertex = g["start", :name]
# total_paths = num_paths(g, start_vertex)

# printfmt("total paths: {:d}", total_paths)
 

function num_paths_part_2(g, v)
    sg = copy(g)
    name = get_prop(sg, v, :name)
    timesVisited = get_prop(sg, v, :visited) + 1
    if !(isBigCave(sg, v) || isTerminal(sg,v)) && get_prop(sg, :smallCaveTwice) && timesVisited > 1
        return 0
    end
    set_prop!(sg, v, :visited, timesVisited)
    remaining_names = [get_prop(sg, u, :name) for u in vertices(sg)]
    if name == "end"
        return  1
    end

    if !isBigCave(sg, v) && timesVisited > 1
        set_prop!(sg, :smallCaveTwice, true)
    end
    if !canVisitAgain(sg, v) 
        rem_vertex!(sg, v)
    end

    paths = [num_paths_part_2(copy(sg), sg[get_prop(g, u, :name), :name]) for u in neighbors(g,v)]
    return sum(paths) 
end

start_vertex = g["start", :name]
total_paths = @time num_paths_part_2(g, start_vertex)
printfmt("total paths part 2: {:d}", total_paths)

function paths_part_2(g, v, prev_path) 
    sg = copy(g)
    name = get_prop(sg, v, :name)
    timesVisited = get_prop(sg, v, :visited) + 1
    if !(isBigCave(sg, v) || isTerminal(sg,v)) && get_prop(sg, :smallCaveTwice) && timesVisited > 1
        return []
    end

    set_prop!(sg, v, :visited, timesVisited)
    remaining_names = [get_prop(sg, u, :name) for u in vertices(sg)]
    
    path_to_here = copy(prev_path)
    push!(path_to_here, name)
    if name == "end"
        return [path_to_here]
    end
    if !isBigCave(sg, v) && timesVisited > 1
        set_prop!(sg, :smallCaveTwice, true)
    end
    if !canVisitAgain(sg, v) 
        rem_vertex!(sg, v)
    end

    all_paths = []
    for u in neighbors(g,v)
        nu = sg[get_prop(g, u, :name), :name]
        paths_from_neighbour = paths_part_2(copy(sg), nu, copy(path_to_here))
        push!(all_paths, paths_from_neighbour...)
    end
    return all_paths
end

# all_paths = sort(paths_part_2(g, start_vertex, []))
# # printfmt("all_paths: {:}\n", all_paths)
 
# printfmt("\nnumber of paths: {:d}", length(all_paths))


