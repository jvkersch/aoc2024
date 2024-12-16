using DataStructures

I = CartesianIndex{2}

mutable struct Guardian
    pos::I
    direction::Int
end

Guardian(pos::CartesianIndex{2}) = Guardian(pos, 1)

DIRECTIONS = [I(-1, 0), I(0, 1), I(1, 0), I(0, -1)]

nextposition(g::Guardian) = g.pos + DIRECTIONS[g.direction]
step!(g::Guardian) = (g.pos = nextposition(g))
turnright!(g::Guardian) = (g.direction = 1 + g.direction % 4)

isoutside(p::I, grid::Matrix) = !Base.checkbounds(Bool, grid, p)

readdata() = permutedims(hcat(collect.(readlines("inputs/day06.txt"))...))

findguardian(grid) = Guardian(first(findall(pos -> pos == '^', grid)))
markgrid!(grid, g::Guardian) = (grid[g.pos] = 'X')

function walk(grid)
    grid = copy(grid)
    g = findguardian(grid)
    markgrid!(grid, g)
    while true
        next = nextposition(g)
        isoutside(next, grid) && break

        if grid[next] == '#'
            turnright!(g)
        else
            g.pos = next
            markgrid!(grid, g)
        end
    end
    return grid
end

part1() = sum(walk(readdata()) .== 'X')