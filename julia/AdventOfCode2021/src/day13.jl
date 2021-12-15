using Formatting
using SparseArrays


f = open(joinpath(@__DIR__, "../input/day13.txt"));
folds = []
dots = []
for line in readlines(f)
    if startswith(line, "fold")
        dim, position = collect(split(line[11:end], "="))
        push!(folds, Dict(strip(dim)=>parse(Int,position)))
    elseif length(line) > 0
        dot = [parse(Int, n) for n in split(line, ",")]
        push!(dots, dot)
    end
end 

rows= [d[2]+1 for d in dots]
cols = [d[1]+1 for d in dots]
values = ones(Int, size(cols))
A = sparse(rows, cols, values)


function foldY(M, y)
    upper = M[1:y, :]
    lower = M[end:-1:y+2, :]
    folded = upper + lower
    return folded.>=1
end

function foldX(M, x)
    left = M[:, 1:x]
    right = M[:, end:-1:x+2]
    folded = left + right
    return folded.>=1
end

function applyFolds(M, folds)
    Z = copy(M)
    for fold in folds
        if haskey(fold,"x")
            Z = foldX(Z, fold["x"])
        elseif haskey(fold,"y")
            Z = foldY(Z, fold["y"])
        end
    end
    return Z 
end

function printOrigami(M)
    print("\n\n")
    X = Matrix(M)
    m,n = size(X)
    for i in 1:m
        for j in 1:n
            X[i,j] > 0 ? print("#") : print(".")
        end
        print("\n")
    end
end
oneFold = applyFolds(A, folds[1:1])
dotCount = count(oneFold.>=1)
printfmt("\nDots after One Fold: {}", dotCount)
# printfmt("\nfolded: {}", Matrix(folded))
folded = applyFolds(A, folds)
printOrigami(folded)
