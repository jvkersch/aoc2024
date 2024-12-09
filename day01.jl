using DelimitedFiles

data = readdlm("inputs/day01.txt", Int64)
println(sum(abs.(sort(data[1:end, 1]) - sort(data[1:end, 2]))))

counts = zeros(Int64, maximum(data))
for el ∈ data[1:end, 2] counts[el] += 1
println(sum(data[1:end, 1] .* counts[data[1:end, 1]]))