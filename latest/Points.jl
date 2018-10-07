module Points

using Random

import Base: zero, zeros, rand
import Base: +, -, *, /, \
import Base: abs, abs2

export Point, update, plot_str

abstract type Point end

zero(x :: Point) = zero(typeof(x))
rand(x :: Point) = rand(typeof(x))

function zeros(::Type{P}, dims::Union{Integer, AbstractUnitRange}...) where {P<:Point}
    ret = Array{P}(undef, dims...)
    for i in 1:length(ret)
        ret[i] = zero(P)
    end
    return ret
end

*(p :: Point, a :: Real) = a*p
\(a :: Real, p :: Point) = p/a

abs(p :: Point) = sqrt(abs2(p))

update(p :: Point) = p + rand(p)

include("Point1d.jl")
include("Point2d.jl")

end ## of module Points
