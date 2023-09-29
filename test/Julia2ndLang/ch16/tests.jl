using Test
using JuliaStudy.Julia2ndLang.ToyGeometry: cosine, sine

@testset "cosine tests" begin
  @test cosine(π) ≈ -1.0
  @test cosine(0) ≈ 1.0
  for x in 0:0.1:(2π)
    @test isapprox(cos(x), cosine(x), atol = 0.05)
  end
end

@testset "sine tests" begin
  @test sine(0) ≈ 0.0
  @test sine(π / 2) ≈ 1.0
  for x in 0:0.1:(2π)
    @test isapprox(sin(x), sine(x), atol = 0.05)
  end
end
