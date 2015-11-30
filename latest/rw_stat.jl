include("Points.jl")
using Points

function mean_var{P<:Point}(ps :: Array{P})
  m = mean(ps)
  ps2 = map(p->abs2(p-m),ps)
  v = sum(ps2)/(length(ps2)-1)
  return abs(m),v
end

function randomwalk{P<:Point}(::Type{P}, num::Integer, nsteps::Integer)
  means, vars = zeros(nsteps+1), zeros(nsteps+1)
  ps = zeros(P,num)
  means[1], vars[1] = mean_var(ps)
  for t in 0:nsteps
    map!(update, ps)
    means[t+1], vars[t+1] = mean_var(ps)
  end
  means, vars
end
