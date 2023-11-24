module TypesTypeInferenceStability

# Declare type of function argument
iam(x::Integer) = "an integer"
iam(x::String) = "a string"

function addme(a, b)
  # Declare type of local variable x
  x::Int64 = 2
  # Type of variable y will be inferred
  y = (a + b) / x
  return y
end

sumsqr(x, y) = x^2 + y^2

struct Pixel
  x::Int64
  y::Int64
  color::Int64
end

mutable struct MPixel
  x::Int64
  y::Int64
  color::Int64
end

struct Pixeln{T}
  x::Int64
  y::Int64
  color::T
end

# Type unstable function
function pos(x)
  if x < 0
    return 0
  else
    return x
  end
end

function pos_fixed(x)
  if x < 0
    return zero(x)
  else
    return x
  end
end

function sumsqrtn(n)
  r = 0
  for i in 1:n
    r = r + sqrt(i)
  end
  return r
end

function sumsqrtn_fixed(n)
  r = 0.0
  for i in 1:n
    r = r + sqrt(i)
  end
  return r
end

# for @simd macro
# See: https://docs.julialang.org/en/v1/base/base/#Base.SimdLoop.@simd
function simdsum(x)
  s = 0
  @simd for v in x
    s += v
  end
  return x
end

function simdsum_fixed(x)
  s = zero(eltype(x))
  @simd for v in x
    s += v
  end
  return x
end

function string_zeros(s::AbstractString)
  n = 1_000_000
  x = s == "Int64" ?
      Vector{Int64}(undef, n) :
      Vector{Float64}(undef, n)
  for i in 1:length(x)
    x[i] = 0
  end
  return x
end

function string_zeros_stable(s::AbstractString)
  n = 1_000_000
  x = s == "Int64" ?
      Vector{Int64}(undef, n) :
      Vector{Float64}(undef, n)
  return fill_zeros(x)
end

function fill_zeros(x)
  for i in 1:length(x)
    x[i] = 0
  end
  return x
end

function arr_sumsqr(x::Array{T}) where {T <: Number}
  r = zero(T)
  for i in 1:length(x)
    r = r + x[i]^2
  end
  return r
end

struct Point
  x::Any
  y::Any
end

struct ConcretePoint
  x::Float64
  y::Float64
end

function sumsqr_points(a)
  s = 0.0
  for x in a
    s = s + x.x^2 + x.y^2
  end
  return s
end

struct PointWithAbstract
  x::AbstractFloat
  y::AbstractFloat
end

struct ParametricPoint{T <: AbstractFloat}
  x::T
  y::T
end

end
