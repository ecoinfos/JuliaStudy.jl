using Test
import JuliaStudy.JuliaPatterns.PrototypePattern as ProtP

@testset "Prototype Pattern" begin
  ProtP.test(copy)
  ProtP.test(deepcopy)
end
