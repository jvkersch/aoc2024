function parseline(line)
    numbers = parse.(Int, [m.match for m ∈ eachmatch(r"\d+", line)])
    return numbers[1], numbers[2:end]
end

readdata() = parseline.(readlines("inputs/day07.txt"))

function hascombination2(total, numbers)
    length(numbers) == 1 && return total == numbers[1]
    total > numbers[end] && hascombination2(total - numbers[end], numbers[1:end-1]) && return true
    mod(total, numbers[end]) == 0 && hascombination2(total ÷ numbers[end], numbers[1:end-1]) && return true
    return false
end

function prefix(total, n)
    while n > 0
        total, d1 = divrem(total, 10)
        n, n1 = divrem(n, 10)
        d1 == n1 || return -1
    end
    return total
end

function hascombination3(total, numbers)
    length(numbers) == 1 && return total == numbers[1]
    total > numbers[end] && hascombination3(total - numbers[end], numbers[1:end-1]) && return true
    mod(total, numbers[end]) == 0 && hascombination3(total ÷ numbers[end], numbers[1:end-1]) && return true

    leading = prefix(total, numbers[end])
    leading > 0 && hascombination3(leading, numbers[1:end-1]) && return true
    return false
end

part1() = sum([hascombination2(total, ns) ? total : 0 for (total, ns) ∈ readdata()])
part2() = sum([hascombination3(total, ns) ? total : 0 for (total, ns) ∈ readdata()])

