using Formatting

struct BingoBoard
   numbers::Dict{Int, Tuple}
   m::Int
   n::Int
   filled::Matrix{Int}
end

function createBingoBoard(input)
    m = length(input)
    n = length(input[1]) 

    numbers = Dict()
    for i in 1:m
        for j in 1:n
            numbers[input[i][j]] = (i,j)
        end
    end 

    filled = zeros(Int64,m,n)

    return BingoBoard(numbers, m,n,filled)

end

function updateBoard!(number::Int, board::BingoBoard) 
    if haskey(board.numbers, number)
        i, j = board.numbers[number]
        board.filled[i,j] = 1
    end
end

function isWinningBoard(board::BingoBoard) 
    return maximum(sum(board.filled, dims=2)) == board.m ||  maximum(sum(board.filled, dims=1)) == board.n
end


f = open(joinpath(@__DIR__, "../input/day04.txt"));
bingoNumbers = [parse(Int, n) for n in split(readline(f),",")]

readline(f)

bingoBoards= []
currentBingoCard = []
while !eof(f)
    line = readline(f)
    if length(line) > 0  
        row = [parse(Int, n) for n in split(line," ", keepempty=false)]
        push!(currentBingoCard, row)
    else
        push!(bingoBoards, createBingoBoard(currentBingoCard))
        global currentBingoCard = []
    end
end 

if length(currentBingoCard) > 0
    push!(bingoBoards, createBingoBoard(currentBingoCard))
end


function playBingo(numbers, boards)
    for number in numbers
        for board in boards
            updateBoard!(number, board)
            if isWinningBoard(board)
                return board, number
            end
        end
    end
end

function sumOfUnmarkedNumbers(board::BingoBoard)
    s = 0
    for (number, (i,j)) in board.numbers
        if board.filled[i,j] == 0 
            s += number
        end
    end
    return s
end
# winningBoard, lastNumber = playBingo(bingoNumbers, bingoBoards)

# unmarked = sumOfUnmarkedNumbers(winningBoard)


# printfmt("unmarked: {:d}\n", unmarked)
# printfmt("lastNumber: {:d}\n", lastNumber)
# printfmt("product: {:d}\n", unmarked * lastNumber)

# println(winningBoard)


function playReverseBingo(numbers, boards)
    winningBoards = Set()
    for number in numbers
        for board in boards
            updateBoard!(number, board)
            if isWinningBoard(board)
                if length(winningBoards) == (length(boards) - 1) && !in(board, winningBoards)
                    return board, number
                else
                    push!(winningBoards, board)
                end
            end
        end
    end
end

lastWinningBoard, lastNumber = playReverseBingo(bingoNumbers, bingoBoards)
    

unmarked = sumOfUnmarkedNumbers(lastWinningBoard)


printfmt("unmarked: {:d}\n", unmarked)
printfmt("lastNumber: {:d}\n", lastNumber)
printfmt("product: {:d}\n", unmarked * lastNumber)

println(lastWinningBoard)
