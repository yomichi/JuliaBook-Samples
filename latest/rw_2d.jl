push!(LOAD_PATH, ".")
using Points

using Plots

function randomwalk(nsteps::Integer)
    ps = zeros(Point2D, nsteps+1)
    for i in 1:nsteps
        ps[i+1] = update(ps[i])
    end
    return ps
end

ps = randomwalk(1001)
xs = map(p->p.x, ps)
ys = map(p->p.y, ps)

pl = plot(xs, ys, xaxis="x", yaxis="y", color=:black, legend=false)
savefig(pl, "rw_2d.pdf")
