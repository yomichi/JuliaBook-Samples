# Point in 1D space

export Point1D

type Point1D <: Point
  x :: Float64
end

point(x) = Point1D(x)
zero(::Type{Point1D}) = Point1D(0.0)

if VERSION < v"0.4.0"
  function rand(::Type{Point1D})
    return Point1D(ifelse(rand() < 0.5, 1.0, -1.0))
  end
  function rand(r::AbstractRNG, ::Type{Point1D})
    return Point1D(ifelse(rand(r) < 0.5, 1.0, -1.0))
  end
else
  function rand(r::AbstractRNG, ::Type{Point1D})
    return Point1D(ifelse(rand(r) < 0.5, 1.0, -1.0))
  end
end

+(lhs :: Point1D, rhs :: Point1D) = Point1D(lhs.x + rhs.x)
-(lhs :: Point1D, rhs :: Point1D) = Point1D(lhs.x - rhs.x)
-(p :: Point1D) = Point1D(-p.x)
*(a :: Real, p :: Point1D) = Point1D(a*p.x)
/(p :: Point1D, a :: Real) = Point1D(p.x/a)

abs(p :: Point1D) = abs(p.x)
abs2(p :: Point1D) = p.x*p.x

plot_str(p::Point1D) = string(p.x)
