makelevel(line) = parse.(Int, split(line, ' '))
levels = open("inputs/day02.txt") do f
    makelevel.(readlines(f))
end

isdecreasing(s) = all(s .< 0)
isincreasing(s) = all(s .> 0)
isnotsteep(s) = all(1 .<= abs.(s) .<= 3)

function issafe(level) 
    s = diff(level)    
    (isdecreasing(s) || isincreasing(s)) && isnotsteep(s)
end

println(sum(issafe.(levels)))

removesteps(level) = [deleteat!(copy(level), i) for i ∈ eachindex(level)]
canbemadesafe(level) = issafe(level) || any(issafe.(removesteps(level)))

println(sum(canbemadesafe.(levels)))