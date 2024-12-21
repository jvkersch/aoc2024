using DataStructures
using Combinatorics

const I = CartesianIndex

readdata() = permutedims(hcat(collect.(readlines("inputs/day08.txt"))...))

function find_antennas(grid)
    antennas =  DefaultDict{Char, Vector{I}}(() -> I[])
    for loc ∈ findall(grid .!= '.')
        push!(antennas[grid[loc]], loc)
    end
    return antennas
end

function find_antinodes(grid, antennas)
    antinodes = Set{I}()
    for antennas_for_type ∈ values(antennas)
        for (a1, a2) in combinations(antennas_for_type, 2)
            push!(antinodes, 2*a2 - a1)
            push!(antinodes, 2*a1 - a2)
        end
    end
    filter(idx -> checkbounds(Bool, grid, idx), antinodes)
end

function find_antinodes_resonant(grid, antennas)
    antinodes = Set{I}()
    for antennas_for_type ∈ values(antennas)
        for (a1, a2) ∈ combinations(antennas_for_type, 2)
            delta = a2 - a1
            n2 = a2 + delta
            while checkbounds(Bool, grid, n2)
                push!(antinodes, n2)
                n2 += delta
            end
            n1 = a1 + delta
            while checkbounds(Bool, grid, n1)
                push!(antinodes, n1)
                n1 -= delta
            end
        end
    end
    antinodes
end

function part1()
    grid = readdata()
    antennas = find_antennas(grid)
    antinodes = find_antinodes(grid, antennas)
    println(length(antinodes))
end

function part2()
    grid = readdata()
    antennas = find_antennas(grid)
    antinodes = find_antinodes_resonant(grid, antennas)
    println(length(antinodes))
end