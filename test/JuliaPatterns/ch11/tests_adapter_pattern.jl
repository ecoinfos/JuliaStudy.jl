using Test
import JuliaStudy.JuliaPatterns.AdapterPattern as AdaP

LL = AdaP.list(1)
insert!(LL, 2)
insert!(AdaP.next(LL), 3)

@testset "Linked List" begin
  LL
  @test_throws MethodError length(LL)
  @test_throws MethodError LL[1]
end

@testset "MyArray" begin
  ar = AdaP.MyArray(LL)
  @test length(ar) == 3
  @test ar[1] == 1
  @test ar[end] == 3
  @test_throws BoundsError ar[4]
end
