include("rw_stat.jl")

dim = length(ARGS)>0 ? parse(Int, ARGS[1]) : 1
num = length(ARGS)>1 ? parse(Int, ARGS[2]) : 1000
nsteps = length(ARGS)>2 ? parse(Int, ARGS[3]) : 1000
filename = length(ARGS)>3 ? ARGS[4] : ""

if dim == 1
    P = Point1D
elseif dim == 2
    P = Point2D
else
    error("dimension error!")
end

if isempty(filename)
    io = stdout
else
    io = open(filename, "w")
end

means, vars = randomwalk(P, num, nsteps)

for (i, (m, v)) in enumerate(zip(means, vars))
    println(io, i-1, " ", m, " ", v)
end
