readdata() = [parse(Int, ch) for ch ∈ readline("inputs/day09.txt")]

function expand_diskmap(diskmap)
    expanded = Int[]
    blank = false
    id = 0
    for block ∈ diskmap
        append!(expanded, fill(blank ? -1 : id, block))
        blank || (id += 1)
        blank = !blank
    end
    expanded
end

print_expanded(expanded) = join([entry >= 0 ? entry : '.' for entry in expanded])

function find_next_empty(expanded, i)
    while expanded[i] >= 0
        i += 1
    end
    i
end

function find_previous_full(expanded, j)
    while expanded[j] < 0
        j -= 1
    end
    j
end

function defrag(expanded)
    expanded = copy(expanded)
    i, j = 1, length(expanded)
    while true
        i = find_next_empty(expanded, i)
        j = find_previous_full(expanded, j)
        i < j || break
        expanded[i] = expanded[j]
        expanded[j] = -1
    end
    expanded
end

checksum(expanded) = sum([id < 0 ? 0 : (n - 1) * id for (n, id) ∈ enumerate(expanded)])

part1() = readdata() |> expand_diskmap |> defrag |> checksum