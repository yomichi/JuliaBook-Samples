using Plots

include("rw_1d.jl")

nsteps = length(ARGS)>0 ? parse(Int, ARGS[1]) : 1000
prob = length(ARGS)>1 ? parse(Float64, ARGS[1]) : 0.5

result = randomwalk(nsteps,prob)

pl = plot(result, xaxis=("t"), yaxis=("x"), color=[:black], legend=false)
savefig(pl, "rw_1d.pdf")
