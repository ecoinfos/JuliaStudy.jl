using Test
import JuliaStudy.JuliaPatterns.PerformaceImpactException as PI
using BenchmarkTools

@testset "Performace impact on exception" begin
  xs = ones(100) 
  @btime PI.sum_of_sqrt1($xs)
  @btime PI.sum_of_sqrt2($xs)
  @btime PI.sum_of_sqrt3($xs)
end

