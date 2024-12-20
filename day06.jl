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
markvisited!(board, g::Guardian) = (board[g.pos] |= 2 << g.direction)
hascycle(board, g::Guardian) = board[g.pos] & (2 << g.direction) > 0

function walk(grid)
    visited = zeros(Int, size(grid))
    g = findguardian(grid)
    markvisited!(visited, g)
    while true
        next = nextposition(g)
        isoutside(next, grid) && break

        if grid[next] == '#'
            turnright!(g)
        else
            g.pos = next
            if hascycle(visited, g)
                return true, visited
            end
            markvisited!(visited, g)
        end
    end
    return false, visited
end

part1() = sum(walk(readdata())[2] .> 0)

function part2()
    grid = readdata()
    n = 0
    for c ∈ CartesianIndices(grid)
        newgrid = copy(grid)
        newgrid[c] != '.' && continue
        newgrid[c] = '#'
        cycle, _ = walk(newgrid)
        cycle && (n += 1)
    end
    n
end