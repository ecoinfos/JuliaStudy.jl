include("setup.jl")

@testset "Chapter 2" begin
  @testset "interest" begin
    @test interest(1, 1) == 2
    @test Calculator.interest(1, 1) == 2
    @test JuliaPatterns.Calculator.interest(1, 1) == 2
    @test parentmodule(interest) == Calculator
  end
  @testset "rate" begin
    @test rate(1, 1) == 1
    @test rate(1, 2) == 2
    @test rate(2, 1) == 0.5
    @test rate(3, 1) ≈ 0.33 rtol=1e-2
  end
end
