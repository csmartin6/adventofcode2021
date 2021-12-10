using Formatting
using Statistics

function firstIllegalCharacter(chunk)
    # open_braces = Dict('('=>0, '['=>0, '{'=>0, '<'=>0)
    open_braces = []
    for c in collect(chunk)
        if c in ['(', '[', '{', '<']
            push!(open_braces, c)
        elseif c == ')'
            if open_braces[end] != '('
                return ')'
            else
                open_braces = open_braces[1:end-1]
            end
        elseif c == ']'
            if open_braces[end] != '['
                return ']'
            else
                open_braces = open_braces[1:end-1]
            end
        elseif c == '}'
            if open_braces[end] != '{'
                return '}'
            else
                open_braces = open_braces[1:end-1]
            end
        elseif c == '>'
            if open_braces[end] != '<'
                return '>'
            else
                open_braces = open_braces[1:end-1]
            end
        end
    end
    return 'g'
end

f = open(joinpath(@__DIR__, "../input/day10.txt"));
lines = readlines(f)

illegalcharacters = [firstIllegalCharacter(line) for line in lines]

scores = Dict('g'=> 0, ')'=> 3,  ']'=>57, '}'=>1197, '>'=>25137)
score = sum([scores[c] for c in illegalcharacters])

printfmt("\nscore: {}\n", score)



function testChunk(chunk)
    # open_braces = Dict('('=>0, '['=>0, '{'=>0, '<'=>0)
    open_braces = []
    for c in collect(chunk)
        if c in ['(', '[', '{', '<']
            push!(open_braces, c)
        elseif c == ')'
            if open_braces[end] != '('
                return ')', open_braces
            else
                open_braces = open_braces[1:end-1]
            end
        elseif c == ']'
            if open_braces[end] != '['
                return ']', open_braces
            else
                open_braces = open_braces[1:end-1]
            end
        elseif c == '}'
            if open_braces[end] != '{'
                return '}', open_braces
            else
                open_braces = open_braces[1:end-1]
            end
        elseif c == '>'
            if open_braces[end] != '<'
                return '>', open_braces
            else
                open_braces = open_braces[1:end-1]
            end
        end
    end
    return 'g', open_braces
end

function completionScore(open_braces) 
    score = 0
    char_scores = Dict('('=> 1,  '['=>2, '{'=>3, '<'=>4)
    for c in reverse(open_braces)
        score = 5 * score + char_scores[c]
    end
    return score
end


score = sum([scores[c] for c in illegalcharacters])
tests = [testChunk(line) for line in lines]

incomplete = [t[2] for t in filter(t->t[1] == 'g' && length(t[2])> 0, tests)]
#incomplete = filter(t->t[1] != 'g', tests)
scores = [completionScore(i) for i in incomplete]
printfmt("\nscores: {}\n", scores)
printfmt("\nmedian: {}\n", Int(median(scores)))
