include("rw_1d.jl")

nsteps = length(ARGS)>0 ? parse(ARGS[1]) : 1000
prob = length(ARGS)>1 ? parse(ARGS[1]) : 0.5

result = randomwalk(nsteps,prob)

for (t,x) in enumerate(result)
    println("$(t-1) $x")
end

