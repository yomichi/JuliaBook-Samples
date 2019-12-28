# Point in 1D space

export Point1D

mutable struct Point1D <: Point
    x :: Float64
end

point(x) = Point1D(x)
zero(::Type{Point1D}) = Point1D(0.0)
rand(r::AbstractRNG, ::Random.SamplerType{Point1D}) = Point1D(rand(r, [1.0, -1.0]))

+(lhs :: Point1D, rhs :: Point1D) = Point1D(lhs.x + rhs.x)
-(lhs :: Point1D, rhs :: Point1D) = Point1D(lhs.x - rhs.x)
-(p :: Point1D) = Point1D(-p.x)
*(a :: Real, p :: Point1D) = Point1D(a*p.x)
/(p :: Point1D, a :: Real) = Point1D(p.x/a)

abs(p :: Point1D) = abs(p.x)
abs2(p :: Point1D) = p.x*p.x

plot_str(p::Point1D) = string(p.x)
