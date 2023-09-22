module MemorizationPattern

using Caching, CSV, DataFrames

export fib, fib2, fib3, fib4, memorize, op, sum_abs, sum_abs2
export read_csv

fib(n) = n < 3 ? 1 : fib(n - 1) + fib(n - 2)

function fib2(n)
  if n < 3
    return (result = 1, counter = 1)
  else
    result1, counter1 = fib2(n - 1)
    result2, counter2 = fib2(n - 2)
    return (result = result1 + result2, counter = 1 + counter1 + counter2)
  end
end

const fib_cache = Dict()

_fib3(n) = n < 3 ? 1 : fib3(n - 1) + fib3(n - 2)

function fib3(n)
  if haskey(fib_cache, n)
    return fib_cache[n]
  else
    value = _fib3(n)
    fib_cache[n] = value
    return value
  end
end

fib4 = n -> begin
  println("called with n = $n")
  return n < 3 ? 1 : fib4(n - 1) + fib4(n - 2)
end

function memorize(f)
  memo = Dict()
  x -> begin
    if haskey(memo, x)
      # println("Cash hit $x")
      return memo[x]
    else
      # println("Cash missed $x")
      return memo[x] = f(x)
    end
  end
end

fib4 = memorize(fib4)

function memorize2(f)
  memo = Dict()
  (args...; kwargs...) -> begin
    x = (args, kwargs)
    if haskey(memo, x)
      return memo[x]
    else
      return memo[x] = f(args...; kwargs...)
    end
  end
end

# Simulate a slow function with positional arguments and keywords arguments
slow_op = (a, b = 2; c = 3, d) -> begin
  sleep(2)
  a + b + c + d
end

op = memorize2(slow_op)

slow_sum_abs = (x::AbstractVector{T} where {T <: Real}) -> begin
  sleep(2)
  sum(abs(v) for v in x)
end

sum_abs = memorize2(slow_sum_abs)

function hash_all_args(args, kwargs)
  h = 0xed98007bd4471dc2
  h += hash(args, h)
  h += hash(kwargs, h)
  return h
end

function memorize3(f)
  memo = Dict()
  (args...; kwargs...) -> begin
    key = hash_all_args(args, kwargs)
    if haskey(memo, key)
      return memo[key]
    else
      return memo[key] = f(args...; kwargs...)
    end
  end
end

sum_abs2 = memorize3(slow_sum_abs)

function read_csv(filename::AbstractString)
  println("Reading file: ", filename)
  @time df = CSV.File(filename) |> DataFrame
  return df
end

end
