using Test
import JuliaStudy.JuliaPatterns.PiracyAntiPattern as PA
using SparseArrays
using BenchmarkTools

@testset "Narrow argument types anti-Pattern" begin
  PA.test_sumprod(PA.sumprod_1)

  PA.test_sumprod(PA.sumprod_2)
  @test (Vector{Float64} <: Vector{Number}) == false

  PA.test_sumprod(PA.sumprod_3)

  PA.test_sumprod(PA.sumprod_4)

  PA.test_sumprod(PA.sumprod_5)

  PA.test_sumprod(PA.sumprod_6)

  A = sparse([1, 10, 100], [1, 10, 100], [1, 2, 3])
  B = sparse([1, 10, 100], [1, 10, 100], [4, 5, 6])
  @test PA.sumprod_6(A, B) == 32

  PA.test_sumprod(PA.sumprod_7)

  A1 = rand(10_000)
  B1 = rand(10_000)

  @btime PA.sumprod_1($A1, $B1)
  @btime PA.sumprod_5($A1, $B1)
  @btime PA.sumprod_6($A1, $B1)
  @btime PA.sumprod_7($A1, $B1)

  @test PA.Point3(0x01, 0x01) |> sizeof == 2
  @test PA.Point(0x01, 0x01) |> sizeof == 16
  @test PA.Point(Int128(1), Int128(1)) |> sizeof == 16
  @test PA.Point4(Int128(1), Int128(1)) |> sizeof == 32

  p = PA.Point6(0x01, 0x01)
  @test sizeof(p) == 2

  p2 = PA.Point6(Int128(1), Int128(1))
  @test sizeof(p2) == 32

  points = PA.make_points(PA.PointAny, 10_000)
  @btime PA.center($points)

  points2 = PA.make_points(PA.Point6, 10_000)
  @btime PA.center($points2)
end
