import Random

struct Die
    nsides::Int
end
Base.eltype(::Type{Die}) = Int

function Random.rand(rng::Random.AbstractRNG, ::Random.SamplerType{Die})
    Die(rand(rng, 4:20))
end

function Random.rand(rng::Random.AbstractRNG, d::Random.SamplerTrivial{Die})
    rand(rng, 1:d[].nsides)
end

Random.seed!(1234)
println(rand(Die))
println(rand(Die,3))
println(rand(Die(5)))
println(rand(Die(5),3))

struct Weights
    w::Vector{Float64}
end
Base.eltype(::Type{Weights}) = Int

function Random.Sampler(::Type{<:Random.AbstractRNG}, weights::Weights, ::Random.Repetition)
    Random.SamplerSimple(weights, cumsum(weights.w))
end
function Random.rand(rng::Random.AbstractRNG, sp::Random.SamplerSimple{Weights})
    r = rand(rng)*(sp.data)[end]
    searchsortedfirst(sp.data, r)
end

Random.seed!(1234)
weights = Weights([1, 2, 3, 4])
println(rand(weights))
println(rand(weights, 10))
