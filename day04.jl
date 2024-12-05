function make_grid(lines; padding=3)
    inner = hcat(map(collect, lines)...)
    rows, cols = size(inner)
    grid = fill('.', rows + 2 * padding, cols + 2 * padding)
    grid[padding+1:end-padding, padding+1:end-padding] = inner
    grid
end

I = CartesianIndex
OFFSETS::Vector{I} = [
    I(-1, -1), I(-1, 0), I(-1, 1), I(0, -1), I(0, 1), I(1, -1), I(1, 0), I(1, 1)
]

words_at(grid, c) = [join([grid[c + i * offset] for i ∈ 0:3]) for offset ∈ OFFSETS]

function count_words(grid)
    nwords = 0
    for c ∈ CartesianIndices(grid)
        grid[c] == 'X' || continue
        nwords += sum(words_at(grid, c) .== "XMAS")
    end
    nwords
end

function part1()
    lines = readlines("inputs/day04.txt")
    grid = make_grid(lines)
    println(count_words(grid))
end