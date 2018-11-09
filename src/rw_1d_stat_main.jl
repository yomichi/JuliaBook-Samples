include("rw_1d_stat.jl")

num = length(ARGS)>0 ? parse(Int, ARGS[1]) : 1000
nsteps = length(ARGS)>1 ? parse(Int, ARGS[2]) : 1000
prob = length(ARGS)>2 ? parse(Float64, ARGS[3]) : 0.5
filename = length(ARGS)>3 ? ARGS[4] : ""

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
