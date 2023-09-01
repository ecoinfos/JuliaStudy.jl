module BarrierFunctionPattern

export random_data, double_sum_of_random_data
export double_sum, double_sum_of_random_data2
export double_sum2, double_sum_of_random_data3

random_data(n) = isodd(n) ? rand(Int, n) : rand(Float64, n)

function double_sum_of_random_data(n)
  data = random_data(n)
  total = 0
  for v in data
    total += 2 * v
  end
  return total
end

function double_sum(data)
  total = 0
  for v in data
    total += 2 * v
  end
  return total
end

function double_sum_of_random_data2(n)
  data = random_data(n)
  return double_sum(data)
end

function double_sum2(data)
  total = zero(eltype(data))
  for v in data
    total += 2 * v
  end
  return total
end

function double_sum_of_random_data3(n)
  data = random_data(n)
  return double_sum2(data)
end

function double_sum3(data::AbstractVector{T}) where {T <: Number}
  total = zero(T)
  for v in data
    total += 2 * v
  end
  return total
end

end
