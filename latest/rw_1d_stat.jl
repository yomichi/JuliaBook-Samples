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

