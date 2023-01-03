using Plots

include("rw_1d_stat.jl")

num = length(ARGS)>0 ? parse(Int, ARGS[1]) : 1000
nsteps = length(ARGS)>1 ? parse(Int, ARGS[2]) : 1000
prob = length(ARGS)>2 ? parse(Float64, ARGS[3]) : 0.5

means, vars = randomwalk(num, nsteps, prob)

pl = plot(means, xaxis=("t"), yaxis=("E[x]"), color=[:black], legend=false)
savefig(pl, "mean.pdf")
pl = plot(vars, xaxis=("t"), yaxis=("V[x]"), color=[:black], legend=false)
savefig(pl, "var.pdf")
