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

