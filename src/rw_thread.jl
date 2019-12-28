using Base.Threads

include("update.jl")

function rw_map(xs, nsteps=10000)
    for i in 1:nsteps
        map!(update, xs, xs)
    end
end

function rw_loop(xs, nsteps=10000)
    num = length(xs)
    for i in 1:nsteps
        @inbounds for j in 1:num
            xs[j] += update(xs[j])
        end
    end
end

function rw_thread(xs, nsteps=10000)
    num = length(xs)
    for i in 1:nsteps
        @inbounds @threads for j in 1:num
            xs[j] += update(xs[j])
        end
    end
end
