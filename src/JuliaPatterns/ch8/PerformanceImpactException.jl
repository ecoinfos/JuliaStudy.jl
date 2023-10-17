module PerformaceImpactException

function sum_of_sqrt1(xs)
  total = zero(eltype(xs))
  for i in eachindex(xs)
    total += sqrt(xs[i])
  end
  return total
end

function sum_of_sqrt2(xs)
  total = zero(eltype(xs))
  for i in eachindex(xs)
    try
      total += sqrt(xs[i])
    catch
      # ignore error intensionally
    end
  end
  return total
end

function sum_of_sqrt3(xs)
  total = zero(eltype(xs))
  for i in eachindex(xs)
    if xs[i] >= 0.0
      total += sqrt(xs[i])
    end
  end
  return total
end

end
