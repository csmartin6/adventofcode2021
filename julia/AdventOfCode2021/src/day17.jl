using Formatting
# teest target area: x=20..30, y=-10..-5
# target area: x=85..145, y=-163..-108
#target_area = [[85 145]; [163 -108]]
target_area = (x=(min=85, max=145), y=(min=-163, max=-108))

# target_area = (x=(min=20, max=30), y=(min=-10, max=-5))

function step(x, y, dx, dy)
    
    nx = x + dx
    ny = y + dy

    ndx = dx - sign(dx)
    ndy = dy - 1
    
    return nx, ny, ndx, ndy
end

function in_target_area(x,y, target_area)
    return x >= target_area.x.min && x <= target_area.x.max && y >= target_area.y.min && y <=target_area.y.max
end

function past_target_area(x, y, target_area)
    return y < target_area.y.min ||  x > target_area.x.max
end

function fire_rocket(idx, idy, target_area)
    x = 0
    y = 0
    dx = idx
    dy = idy
    max_y = 0 

    while !in_target_area(x,y,target_area) && !past_target_area(x,y,target_area)
        x,y,dx,dy = step(x, y, dx, dy)
        max_y = y > max_y ? y : max_y
    end
    return in_target_area(x,y,target_area) ?  max_y : 0
end

function finish_in_target_area(idx, idy, target_area)
    x = 0
    y = 0
    dx = idx
    dy = idy
    max_y = 0 

    while !in_target_area(x,y,target_area) && !past_target_area(x,y,target_area)
        x,y,dx,dy = step(x, y, dx, dy)
        max_y = y > max_y ? y : max_y
    end
    return in_target_area(x,y,target_area)
end


# min_idx = 0
# max_idx = 30
# min_idy = -140
# max_idy = 1000

# max_ys = zeros(Int, max_idx, max_idy)

# for i in 1:max_idx
#     for j in 1:max_idy
#         max_ys[i,j] = fire_rocket(i,j, target_area)
#     end
# end
# max_y, imax = findmax(max_ys)

# printfmt("\nmax height: {} dx: {}\tdy: {}", max_y, imax[1], imax[2])


min_idx = 0
max_idx = target_area.x.max
min_idy = target_area.y.min
max_idy = 1000


in_target = []

for i in min_idx:max_idx
    for j in min_idy:max_idy
        if finish_in_target_area(i,j, target_area)
            push!(in_target, (dx=i, dy=j))
        end
    end
end
printfmt("\ncount finish in target: {}",length(in_target))
