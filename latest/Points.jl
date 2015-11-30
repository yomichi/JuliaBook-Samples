module Points

import Base: zero, zeros, rand
import Base: +, -, *, /, \
import Base: abs, abs2

export Point, update, plot_str

abstract Point

zero(x :: Point) = zero(typeof(x))
rand(x :: Point) = rand(typeof(x))

function zeros{P<:Point}(::Type{P}, dims...)
  ret = Array(P, dims...)
  for i in 1:length(ret)
    ret[i] = zero(P)
  end
  return ret
end

if VERSION < v"0.4.0"
  rand{P<:Point}(::Type{P}, dims::Integer...) = rand!(Array(P,dims...))
  rand{P<:Point}(::Type{P}, dims::Dims) = rand!(Array(P,dims...))
end

*(p :: Point, a :: Real) = a*p
\(a :: Real, p :: Point) = p/a

abs(p :: Point) = sqrt(abs2(p))

update(p :: Point) = p + rand(p)

include("Point1d.jl")
include("Point2d.jl")

end ## of module Points
