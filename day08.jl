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
            if 2*a1-a2 == I(1,1) || 2*a2-a1 == I(1, 1)
                println("here", a1, " ", a2)
            end

            push!(antinodes, 2*a2 - a1)
            push!(antinodes, 2*a1 - a2)
        end
    end
    filter(idx -> checkbounds(Bool, grid, idx), antinodes)
end

function mark_antinodes(grid, antinodes)
    grid = copy(grid)
    grid[[node for node ∈ antinodes]] .= '#'
    grid
end

function part1()
    grid = readdata()
    antennas = find_antennas(grid)
    antinodes = find_antinodes(grid, antennas)
    #mark_antinodes(grid, antinodes)
    println(length(antinodes))
end

part1()