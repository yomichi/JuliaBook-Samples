include("update.jl")

function randomwalk_generator(prob=0.5)
    function rw_impl(c)
        x = 0
        put!(c, x)
        while true
            x = update(x, prob)
            put!(c, x)
        end
    end
    return Channel(rw_impl, spawn=true)
end

function main(nsteps, prob)
    c = randomwalk_generator(prob)
    for (i,x) in enumerate(Iterators.take(c, nsteps+1))
        println(i-1, " ", x)
    end
end
if abspath(PROGRAM_FILE) == @__FILE__
    nsteps = length(ARGS)>0 ? parse(Int, ARGS[1]) : 100
    prob = length(ARGS)>1 ? parse(Float64, ARGS[1]) : 0.5
    main(nsteps, prob)
end
