lines = readlines("inputs/day05.txt")
n = findall(line -> line == "", lines)[1]
rules = Set([parse.(Int, split(line, '|')) for line ∈ lines[1:n-1]])
pagesets = [parse.(Int, split(line, ',')) for line ∈ lines[n+1:end]]

middle_pages::Int = 0
for pageset ∈ pagesets
    global middle_pages
    isvalid = all([[s, t] ∈ rules for (s, t) ∈ zip(pageset[1:end-1], pageset[2:end])])
    isvalid && (middle_pages += pageset[(begin+end)÷2])
end
println(middle_pages)