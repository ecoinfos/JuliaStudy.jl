using Test
import JuliaStudy.JuliaPerformance.TypesTypeInferenceStability as TTIS
using BenchmarkTools

@testset "Types, Type Inference and Stability" begin
  @test TTIS.iam(1) == "an integer"
  @test TTIS.iam("1") == "a string"
  @test_throws MethodError TTIS.iam(1.5)

  @test TTIS.sumsqr(1, 2) == 5
  @test TTIS.sumsqr(1.5, 2.5) == 8.5
  @test TTIS.sumsqr(1 + 2im, 2 + 3im) == -8 + 16im
  @test TTIS.sumsqr(2 + 2im, 2.5) == 6.25 + 8.0im

  p = TTIS.Pixel(5, 5, 100)
  @test_throws ErrorException p.x=10
  @test p.x == 5

  mp = TTIS.MPixel(5, 5, 100)
  mp.x = 10
  @test mp.x == 10
  @show mp

  [x for x in 1:5]

  @test TTIS.pos(-1) == 0
  @test TTIS.pos(2.5) == 2.5

  @test typeof(TTIS.pos(2.5)) == Float64
  @test typeof(TTIS.pos(-2.5)) == Int64

  @test TTIS.pos_fixed(-2.4) == 0.0
  @test typeof(TTIS.pos_fixed(-2.4)) == Float64

  @test TTIS.pos_fixed(-2) == 0
  @test typeof(TTIS.pos_fixed(-2)) == Int64

  @btime TTIS.pos(2.5)
  @btime TTIS.pos_fixed(2.5)

  @code_warntype TTIS.pos(2.5)
  @code_warntype TTIS.pos_fixed(2.5)

  @code_llvm TTIS.pos(2.5)
  @code_llvm TTIS.pos_fixed(2.5)

  @code_native TTIS.pos(2.5)
  @code_native TTIS.pos_fixed(2.5)

  @code_warntype TTIS.sumsqrtn(5)
  @code_warntype TTIS.sumsqrtn_fixed(5)

  @btime TTIS.sumsqrtn(1_000_000)
  @btime TTIS.sumsqrtn_fixed(1_000_000)

  # Cannot run with Pkg.test()
  # a = rand(Float32, 10^6)
  # @btime TTIS.simdsum(a)
  # @btime TTIS.simdsum_fixed(a)

  @btime TTIS.string_zeros("Int64")

  @btime TTIS.string_zeros_stable("Int64")

  a = Int64[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  b = Number[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  @btime TTIS.arr_sumsqr($a)
  @btime TTIS.arr_sumsqr($b)

  p_array = [TTIS.Point(rand(), rand()) for i in 1:1_000_000]
  cp_array = [TTIS.ConcretePoint(rand(), rand()) for i in 1:1_000_000]

  @btime TTIS.sumsqr_points($p_array)
  @btime TTIS.sumsqr_points($cp_array)

  pp_array = [TTIS.ParametricPoint(rand(), rand()) for i in 1:1_000_000]
  @btime TTIS.sumsqr_points($pp_array)
end
