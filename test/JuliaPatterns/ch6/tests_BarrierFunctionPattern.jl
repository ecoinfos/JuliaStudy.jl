using Test
using BenchmarkTools
using JuliaStudy.JuliaPatterns.BarrierFunctionPattern
using InteractiveUtils

@testset "Barrier Function Pattern" begin
  @code_warntype random_data(3)

  @btime double_sum_of_random_data(100_000)

  @btime double_sum_of_random_data(100_001)

  @code_warntype double_sum_of_random_data(100_000)
  @code_warntype double_sum_of_random_data(100_001)

  @btime double_sum_of_random_data2(100_000)
  @btime double_sum_of_random_data2(100_001)

  @code_warntype double_sum(rand(Int, 3))
  @code_warntype double_sum(rand(Float64, 3))

  @code_warntype double_sum_of_random_data3(100_000)
  @code_warntype double_sum_of_random_data3(100_001)

  zero(Int)
  zeros(Float64, 5)

  one(UInt8)
  ones(UInt8, 5)

  A = rand(3, 4)
  B = similar(A)

  zeros(axes(A))

  @test_throws ErrorException @inferred random_data(1)
  @test_throws ErrorException @inferred random_data(2)

  @inferred double_sum(2)
  @inferred double_sum2(2)

  @test_throws ErrorException @inferred double_sum_of_random_data3(100_000)
  @test_throws ErrorException @inferred double_sum_of_random_data3(100_001)
end
