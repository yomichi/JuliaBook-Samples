include("rw_1d_stat.jl")

num = length(ARGS)>0 ? int(ARGS[1]) : 1000
nsteps = length(ARGS)>1 ? int(ARGS[2]) : 1000
prob = length(ARGS)>2 ? float(ARGS[3]) : 0.5
filename = length(ARGS)>3 ? ARGS[4] : ""

if isempty(filename)
  io = open(filename, "w")
else
  io = STDOUT
end

means, vars = randomwalk(num, nsteps, prob=prob)

for (i, (m, v)) in enumerate(zip(means, vars))
  println(io, i-1, " ", m, " ", v)
end
