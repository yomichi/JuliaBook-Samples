include("update.jl")

function randomwalk(num::Integer, nsteps::Integer, prob::Real=0.5)
  means, vars = zeros(nsteps), zeros(nsteps)

  xs = zeros(num)
  means[1] = mean(xs)
  vars[1] = var(xs)
  for t in 1:nsteps
    map!(x -> update(x, prob), xs)
    means[t+1] = mean(xs)
    vars[t+1] = var(xs)
  end
  return means, vars
end

