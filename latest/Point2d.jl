# Point in 2D space

export Point2D

type Point2D <: Point
  x :: Float64
  y :: Float64
end

point(x,y) = Point2D(x,y)
zero(::Type{Point2D}) = Point2D(0.0, 0.0)
if VERSION < v"0.4.0"
  function rand(::Type{Point2D})
    theta = 2pi*Base.rand()
    return Point2D(cos(theta), sin(theta))
  end
  function rand(r::AbstractRNG, ::Type{Point2D})
    theta = 2pi*Base.rand(r)
    return Point2D(cos(theta), sin(theta))
  end
else
  function rand(r::AbstractRNG, ::Type{Point2D})
    theta = 2pi*Base.rand(r)
    return Point2D(cos(theta), sin(theta))
  end
end

+(lhs :: Point2D, rhs :: Point2D) = Point2D(lhs.x + rhs.x, lhs.y + rhs.y)
-(lhs :: Point2D, rhs :: Point2D) = Point2D(lhs.x - rhs.x, lhs.y - rhs.y)
-(p :: Point2D) = Point2D(-p.x, -p.y)
*(a :: Real, p :: Point2D) = Point2D(a*p.x, a*p.y)
/(p :: Point2D, a :: Real) = Point2D(p.x/a, p.y/a)

abs(p :: Point2D) = hypot(p.x, p.y)
abs2(p :: Point2D) = p.x*p.x + p.y*p.y

plot_str(p :: Point2D) = string(p.x, " ", p.y)

