using Test
import JuliaStudy.JuliaPerformance.JuliaIsFast as JulF

@testset "Julia is fast" begin
  @code_native 3^2
  @code_native 3.5^2
end
