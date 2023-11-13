using Test
import JuliaStudy.JuliaPatterns.StrategyPattern as StrategyP

@testset "Strategy pattern" begin
  StrategyP.fib(30)
  StrategyP.fib(60)
end

