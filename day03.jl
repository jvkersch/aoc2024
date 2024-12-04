import PikaParser as P

instructions = open("inputs/day03.txt") do file
    readlines(file)
end

abstract type AbstractResult end

struct NumericalResult <: AbstractResult
    value::Int
end

struct DoResult <: AbstractResult end
struct DontResult <: AbstractResult end

function make_grammar()
    rules = Dict(
        :digits => P.some(:digit => P.satisfy(isdigit)),
        :mulexpr => P.seq(
            P.tokens("mul("),
            :digits,
            P.token(','),
            :digits,
            P.token(')')
        ),
        :doexpr => P.tokens("do()"),
        :dontexpr => P.tokens("don't()"),
        :expr => P.first(:mulexpr, :doexpr, :dontexpr),
    )
    P.make_grammar([:expr], P.flatten(rules, Char))
end

fold(m, p, s) =
    m.rule == :digits ? parse(Int, m.view) :
    m.rule == :expr ? s[1] :
    m.rule == :mulexpr ? NumericalResult(s[2] * s[4]) :
    m.rule == :doexpr ? DoResult() :
    m.rule == :dontexpr ? DontResult() :
    nothing;

function evaluate_matches(p)
    results = Vector{AbstractResult}()
    next_pos = 1
    while next_pos <= lastindex(p.input)
        pos = next_pos
        mid = 0
        while pos <= lastindex(p.input)
            mid = P.find_match_at!(p, :expr, pos)
            mid != 0 && break
            pos = nextind(p.input, pos)
        end

        if mid == 0
            break
        else
            m = p.matches[mid]
            value = P.traverse_match(p, mid, fold=fold)
            push!(results, value)
            next_pos = nextind(p.input, m.last)
        end
    end
    results
end

tovalue(::Int, ::DoResult) = (1, 0)
tovalue(::Int, ::DontResult) = (0, 0)
tovalue(state::Int, v::NumericalResult) = (state, state * v.value)

function process_muls(results::Vector{AbstractResult}; state::Int=1)
    state, sum([tovalue(state, result)[2] for result ∈ results])
end

function process_muls_do_dont(results::Vector{AbstractResult}; state::Int=1)
    sum = 0
    for result ∈ results
        state, v = tovalue(state, result)
        sum += v
    end
    state, sum
end

function process_instructions(instructions; dodont::Bool=false)
    op = dodont ? process_muls_do_dont : process_muls
    state = 1
    sum = 0
    for inst ∈ instructions
        p = P.parse(g, inst)
        results = evaluate_matches(p)
        state, v = op(results; state=state)
        sum += v
    end
    sum
end

g = make_grammar()

println(process_instructions(instructions; dodont=false))
println(process_instructions(instructions; dodont=true))