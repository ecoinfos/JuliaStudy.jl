using Test
import JuliaStudy.JuliaPatterns.CalculatorCh7 as CL
import JuliaStudy.JuliaPatterns.MortgageCh7 as MC

@testset "Access test in funcs.jl" begin
  @test CL.interest(0, 0) == 0
  @test CL.rate(1, 1) == 1
  @test CL.mortgage(1, 1, 1, 1) == 0
end

@testset "Access in MortgageCh7.jl" begin
  @test MC.get_days_per_year() == 365
  @test MC.payment(0, 1.0, 1) == 0
end
