using Distributed

if nworkers() == 1 && 1 in workers()
    addprocs(1)
end

@everywhere include("update.jl")

@everywhere function randomwalk_generator(rc, prob=0.5)
    x = 0
    put!(rc, x)
    while true
        x = update(x, prob)
        put!(rc, x)
    end
end

function main(nsteps, prob)
    rc = RemoteChannel()
    remote_do(randomwalk_generator, 2, rc, 0.5)
    for i in 1:nsteps
        x = take!(rc)
        println(i-1, " ", x)
    end
end
if abspath(PROGRAM_FILE) == @__FILE__
    nsteps = length(ARGS)>0 ? parse(Int, ARGS[1]) : 100
    prob = length(ARGS)>1 ? parse(Float64, ARGS[1]) : 0.5
    main(nsteps, prob)
end
