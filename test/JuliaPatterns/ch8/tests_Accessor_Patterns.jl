using Test
using Distributions
import JuliaStudy.JuliaPatterns.AccessorPatterns as AP

@testset "Accessor Patterns" begin
  sim = AP.simulate(Normal(), 2, 1000)
  sim.stats
end
