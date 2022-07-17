using Formatting

struct SnailFish 
    left::Union{Int, SnailFish}
    right::Union{Int, SnailFish}
end

function magnitude(snail::SnailFish)
    left =  typeof(snail.left) == SnailFish ? magnitude(snail.left) : snail.left
    right =  typeof(snail.right) == SnailFish ? magnitude(snail.right) : snail.right
    return 3 * left + 2 * right
end


function RightMostRegularNumber(snail::Union{SnailFish, Missing})
    if typeof(snail) == Missing
        return 0
    end 
    if typeof(snail.right) == SnailFish
        return RightMostRegularNumber(snail.right)
    end
    if typeof(snail.right) == Int
        return snail.right
    end
end

function LeftMostRegularNumber(snail::Union{SnailFish, Missing})
    if typeof(snail) == Missing
        return 0
    end 
    if typeof(snail.left) == SnailFish
        return LeftMostRegularNumber(snail.left)
    end
    if typeof(snail.left) == Int
        return snail.left
    end
end

function addToLeftMost(snail::SnailFish, n::Int)
    if typeof(snail.left) == Int
        return SnailFish(snail.left + n, snail.right)
    elseif typeof(snail.left) == SnailFish
        return SnailFish(addToLeftMost(snail.left, n), snail.right)
    end
end


function addToRightMost(snail::SnailFish, n::Int)
    if typeof(snail) == Missing
        return snail
    elseif typeof(snail.right) == Int
        return SnailFish(snail.left, snail.right+n)
    elseif typeof(snail.right) == SnailFish
        return SnailFish(snail.left, addToRightMost(snail.right, n))
    end
end


function explodeLeft((snail::SnailFish, depth::Int)
end

# function maybeExplodePair(snail::SnailFish, depth::Int)
#     if depth < 4
#         # maybe explode left
#         didExplode = false
#         if typeof(snail.left) == SnailFish
#             newLeft, didExplode, leftNumber, rightNumber = maybeExplodePair(snail.left, depth+1)
#         end
#         if didExplode
#             return SnailFish(newLeft, addToLeftMost(snail, rightNumber)), true, leftNumber, 0
#         end
#         if typeof(snail.right) == SnailFish
#             newRight, didExplode, leftNumber, rightNumber = maybeExplodePair(snail.right, depth+1)
#         end
#         if didExplode

#             return SnailFish(addToRightMost(snail, leftNumber),newRight), true, 0, rightNumber
#         end
#         return snail, false, 0, 0
#     end

#     # explode left pair
#     return Missing, true, snail.left, snail.right
# end

function maybeExplode(snailFish::SnailFish, depth::Int)

    if depth == 4
        # if left is snailfish (not a int)
        if typeof(snail.left) == SnailFish
            # explode it
            # and return
            return SnailFish(0, snail.right + snail.left.right), true, snail.left.left, 0
        elseif typeof(snail.right) == SnailFish # right is snailFish (not a int)
            # explode it
            # and return
            return SnailFish(snail.left+ snail.right.left, 0), true, 0, snail.right.right
        
        # return
    end

    # see if explossion down left side
    # if there is 
        # add number to leftmost number on right side
        #return 

    # see if explossion down right side
    # if there is 
        # add number to right most number on left side
        # return 
    
    # no explosion rreturn

end


a = SnailFish(3,SnailFish(1,2))
printfmt("\nbefore: {}", a)
after, explosion, toAdd = maybeExplodePair(a, 3)
printfmt("\nafter: {}", after)




# function explode(snailFish::string)

#     depth = 0
#     leftNumberPos = -1
#     for i in length(snailFish)
#         if snailFish[i] == '['
#             depth += 1
#         elseif snailFish[i] == ']'
#             depth -= 1
#         elseif snailFish[i] == ','
#             continue
#         else
#             leftNumberPos = i
#         end

#         if depth == 4
            
#         end
#     end

# end
