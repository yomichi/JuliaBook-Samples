include("rw_1d.jl")

nsteps = length(ARGS)>0 ? int(ARGS[1]) : 1000
prob = length(ARGS)>1 ? float(ARGS[1]) : 0.5

result = randomwalk(nsteps,prob)

for (t,x) in enumerate(result)
  println("$(t-1) $x")
end

