"return `x+1` with probability `p` or `x-1` with `1-p`."
function update(x::Real,p::Real=0.5)
    ifelse(rand() < p, x+one(x), x-one(x))
end

