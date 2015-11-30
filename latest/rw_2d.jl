using Points
using Compat

point(::Val{1}) = Point1D
point(::Val{2}) = Point2D

function randomwalk(vdim::Val, nsteps::Integer)
  P = point(vdim)
  ps = rand(P, nsteps+1)
  cumsum!(ps)
  ps
end
