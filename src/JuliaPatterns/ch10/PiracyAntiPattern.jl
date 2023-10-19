module PiracyAntiPattern

using Statistics: mean

function sumprod_1(A::Vector{Float64}, B::Vector{Float64})
  return sum(A .* B)
end

function sumprod_2(A::Vector{Number}, B::Vector{Number})
  return sum(A .* B)
end

function sumprod_3(A::Vector{T}, B::Vector{T}) where {T <: Number}
  return sum(A .* B)
end

function sumprod_4(A::Vector{S}, B::Vector{T}) where {S <: Number, T <: Number}
  return sum(A .* B)
end

function sumprod_5(A::Array{S, N},
  B::Array{T, N}) where {N, S <: Number, T <: Number}
  return sum(A .* B)
end

function sumprod_6(A::AbstractArray{S, N},
  B::AbstractArray{T, N}) where {N, S <: Number, T <: Number}
  return sum(A .* B)
end

function sumprod_7(A, B)
  return sum(A .* B)
end

function test_harness(f, scenario, args...)
  try
    f(args...)
    println(f, " #$(scenario) success")
  catch ex
    if ex isa MethodError
      println(f, " #$(scenario) failure (method not selected)")
    else
      println(f, " #$(scenario) failure (unknown error $ex)")
    end
  end
end

function test_sumprod(f)
  test_harness(f, 1, [1.0, 2.0], [3.0, 4.0])
  test_harness(f, 2, [1, 2], [3, 4])
  test_harness(f, 3, [1, 2], [3.0, 4.0])
  test_harness(f, 4, rand(2, 2), rand(2, 2))
  test_harness(f, 5, Number[1, 2.0], Number[3.0, 4])
end

struct Point
  x::Any
  y::Any
end

struct PointAny
  x::Any
  y::Any
end

struct Point3
  x::UInt8
  y::UInt8
end

struct Point4
  x::UInt128
  y::UInt128
end

struct Point5
  x::Real
  y::Real
end

struct Point6{T <: Real}
  x::T
  y::T
end

function center(points::AbstractVector{T}) where {T}
  return T(mean(p.x for p in points),
    mean(p.y for p in points))
end

make_points(T::Type, n) = [T(rand(), rand()) for _ in 1:n]

end
