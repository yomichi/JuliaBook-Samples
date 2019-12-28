using Statistics

include("update.jl")

function randomwalk(num::Integer, nsteps::Integer, prob::Real=0.5)
    means, vars = zeros(nsteps+1), zeros(nsteps+1)

    xs = zeros(num)
    means[1] = mean(xs)
    vars[1] = var(xs)
    for t in 1:nsteps
        map!(x -> update(x, prob), xs, xs)
        means[t+1] = mean(xs)
        vars[t+1] = var(xs)
    end
    return means, vars
end

function main(num, nsteps, prob, filename)
    if isempty(filename)
        io = stdout
    else
        io = open(filename, "w")
    end

    means, vars = randomwalk(num, nsteps, prob)

    for (i, (m, v)) in enumerate(zip(means, vars))
        println(io, "$(i-1) $m $v")
    end

    if io != stdout
        close(io)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    num = length(ARGS)>0 ? parse(Int, ARGS[1]) : 1000
    nsteps = length(ARGS)>1 ? parse(Int, ARGS[2]) : 1000
    prob = length(ARGS)>2 ? parse(Float64, ARGS[3]) : 0.5
    filename = length(ARGS)>3 ? ARGS[4] : ""

    main(num, nsteps, prob, filename)
end
