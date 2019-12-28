include("update.jl")

function randomwalk(nsteps::Integer, prob::Real=0.5)
    result = zeros(Int, nsteps+1)
    x = 0
    result[1] = x
    for t in 1:nsteps
        x = update(x,prob)
        result[t+1] = x
    end
    return result
end

function main(nsteps, prob)
    result = randomwalk(nsteps,prob)

    for (t,x) in enumerate(result)
        println("$(t-1) $x")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    nsteps = length(ARGS)>0 ? parse(Int, ARGS[1]) : 1000
    prob = length(ARGS)>1 ? parse(Float64, ARGS[1]) : 0.5

    main(nsteps, prob)
end
