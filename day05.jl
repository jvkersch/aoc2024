function read_data()
    lines = readlines("inputs/day05.txt")
    n = first(findall(line -> line == "", lines))
    rules = Set([parse.(Int, split(line, '|')) for line ∈ lines[1:n-1]])
    pagesets = [parse.(Int, split(line, ',')) for line ∈ lines[n+1:end]]
    return pagesets, rules
end

isvalid(pageset, rules) = all([[s, t] ∈ rules for (s, t) ∈ zip(pageset[1:end-1], pageset[2:end])])

function partition_pagesets(pagesets, rules)
    valid = similar(pagesets, 0)
    invalid = similar(pagesets, 0)
    for ps ∈ pagesets
        push!(isvalid(ps, rules) ? valid : invalid, ps)
    end
    valid, invalid
end

function part1(pagesets, rules)
    valid, _ = partition_pagesets(pagesets, rules)
    middle_pages = sum([pageset[(begin+end)÷2] for pageset ∈ valid])
    println(middle_pages)
end

restrict(nodes, rules) = filter(r -> (r[1] ∈ nodes) && (r[2] ∈ nodes), rules)

function makegraph(rules)
    g = Dict{Int, Vector{Int}}()
    for (s, t) ∈ rules
        haskey(g, s) || (g[s] = [])
        haskey(g, t) || (g[t] = [])
        push!(g[s], t)
    end
    g
end

function toposort(graph)

    function dfs(graph, start, visited, processed)
        push!(visited, start)
        for neigh ∈ graph[start]
            neigh ∈ visited && continue
            dfs(graph, neigh, visited, processed)
        end
        push!(processed, start)
    end

    visited = Set()
    processed = Vector{Int}()
    for vertex ∈ keys(graph)
        vertex ∉ visited && dfs(graph, vertex, visited, processed)
    end
    reverse(processed)
end

function part2(pagesets, rules)
    valid, invalid = partition_pagesets(pagesets, rules)

    middle_pages_fixed = 0
    for pageset ∈ invalid
        g = makegraph(restrict(pageset, rules))
        fixed = toposort(g)
        middle_pages_fixed += fixed[(begin+end)÷2]
    end
    println(middle_pages_fixed)
end

function main()
    pagesets, rules = read_data()
    part1(pagesets, rules)
    part2(pagesets, rules)
end

main()