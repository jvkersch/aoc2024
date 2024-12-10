lines = readlines("inputs/day05.txt")
n = findall(line -> line == "", lines)[1]
rules = Set([parse.(Int, split(line, '|')) for line ∈ lines[1:n-1]])
pagesets = [parse.(Int, split(line, ',')) for line ∈ lines[n+1:end]]

invalid::Vector{Vector{Int}} = []
middle_pages::Int = 0
for pageset ∈ pagesets
    global middle_pages
    isvalid = all([[s, t] ∈ rules for (s, t) ∈ zip(pageset[1:end-1], pageset[2:end])])
    isvalid && (middle_pages += pageset[(begin+end)÷2])
    !isvalid && push!(invalid, pageset)
end
println(middle_pages)

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
    visited = Set()
    processed = Vector{Int}()
    for vertex ∈ keys(graph)
        vertex ∉ visited && dfs(graph, vertex, visited, processed)
    end
    reverse(processed)
end

function dfs(graph, start, visited, processed)
    push!(visited, start)
    for neigh ∈ graph[start]
        neigh ∈ visited && continue
        dfs(graph, neigh, visited, processed)
    end
    push!(processed, start)
end

middle_pages_fixed::Int = 0
for pageset ∈ invalid
    global middle_pages_fixed
    local g = makegraph(restrict(pageset, rules))
    fixed = toposort(g)
    middle_pages_fixed += fixed[(begin+end)÷2]
end
println(middle_pages_fixed)