push!(LOAD_PATH, ".")
using Statistics
using Points

function mean_var(ps :: Array{P}) where {P<:Point}
    m = mean(ps)
    ps2 = map(p->abs2(p-m),ps)
    v = sum(ps2)/(length(ps2)-1)
    return abs(m),v
end

function randomwalk(::Type{P}, num::Integer, nsteps::Integer) where {P<:Point}
    means, vars = zeros(nsteps+1), zeros(nsteps+1)
    ps = zeros(P,num)
    means[1], vars[1] = mean_var(ps)
    for t in 0:nsteps
        map!(update, ps, ps)
        means[t+1], vars[t+1] = mean_var(ps)
    end
    means, vars
end

function main(dim, num, nsteps, filename)
    if dim == 1
        P = Point1D
    elseif dim == 2
        P = Point2D
    else
        error("dimension error!")
    end

    if isempty(filename)
        io = stdout
    else
        io = open(filename, "w")
    end

    means, vars = randomwalk(P, num, nsteps)

    for (i, (m, v)) in enumerate(zip(means, vars))
        println(io, i-1, " ", m, " ", v)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    dim = length(ARGS)>0 ? parse(Int, ARGS[1]) : 1
    num = length(ARGS)>1 ? parse(Int, ARGS[2]) : 1000
    nsteps = length(ARGS)>2 ? parse(Int, ARGS[3]) : 1000
    filename = length(ARGS)>3 ? ARGS[4] : ""

    main(dim, num, nsteps, filename)
end
