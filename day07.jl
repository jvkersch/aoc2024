function parseline(line)
    numbers = parse.(Int, [m.match for m ∈ eachmatch(r"\d+", line)])
    return numbers[1], numbers[2:end]
end

readdata() = parseline.(readlines("inputs/day07.txt"))

function hascombination(total, numbers)
    length(numbers) == 1 && return total == numbers[1]
    total > numbers[end] && hascombination(total - numbers[end], numbers[1:end-1]) && return true
    mod(total, numbers[end]) == 0 &&  hascombination(total ÷ numbers[end], numbers[1:end-1]) && return true
    return false
end

part1() = sum([hascombination(total, ns) ? total : 0 for (total, ns) ∈ readdata()])
