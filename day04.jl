gridlines = [
    "MMMSXXMASM",
    "MSAMXMSMSA",
    "AMXSXMAAMM",
    "MSAMASMSMX",
    "XMASAMXAMM",
    "XXAMMXXAMA",
    "SMSMSASXSS",
    "SAXAMASAAA",
    "MAMMMXMMMM",
    "MXMXAXMASX",
]

# gridlines = [
#     "XUUU",
#     "UMUU",
#     "UUAU",
#     "UUUS"
# ]

function make_grid(lines)
    padding = repeat(".", length(lines[1]) + 2)
    lines = [padding; ["." * line * "." for line ∈ lines]; padding]
    hcat(map(collect, lines)...)
end

I = CartesianIndex
OFFSETS::Vector{I} = [
    I(-1, -1), I(-1, 0), I(-1, 1), I(0, -1), I(0, 1), I(1, -1), I(1, 0), I(1, 1)
]
neighbors(index) = index .+ OFFSETS

grid = make_grid(gridlines)
starts = findall(grid .== 'X')


function dfs(grid, path)
    start = last(path)
    paths = []
    for n ∈ neighbors(start)
        grid[n] != "MAS"[length(path)] && continue
        if length(path) == 3
            push!(paths, [path; n])
        else
            append!(paths, dfs(grid, [path; n]))
        end
    end
    return paths
end

function mark_paths(grid, paths)
    npaths = 0
    isempty = trues(size(grid))
    for p ∈ paths
        if any([isempty[n] for n ∈ p])
            npaths += 1
        end
        for n ∈ p
            isempty[n] = false
        end
    end
    return npaths
end


all_paths = []
for start ∈ starts
    paths = dfs(grid, [start])
    append!(all_paths, paths)
end
println(mark_paths(grid, all_paths))