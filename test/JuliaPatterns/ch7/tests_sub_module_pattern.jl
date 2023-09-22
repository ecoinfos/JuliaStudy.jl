using Test
using JuliaStudy.JuliaPatterns.CalculatorCh7
using JuliaStudy.JuliaPatterns.MortgageCh7

@testset "Access test in funcs.jl" begin
  @test interest(0, 0) == 0
  @test rate(1, 1) == 1
  @test mortgage(1, 1, 1, 1) == 0
end

@testset "Access in MortgageCh7.jl" begin
  @test get_days_per_year() == 365
  @test MortgageCh7.payment(0, 1.0, 1) == 0
end
