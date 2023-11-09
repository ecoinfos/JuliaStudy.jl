using Test
using Printf
import JuliaStudy.JuliaPatterns.FactoryMethodPattern as FM
import JuliaStudy.JuliaPatterns.AbstractFactoryPattern as AF

@testset "Factory method pattern" begin
  @sprintf("%d", 1234)
  @sprintf("%.2f", 1234.567)

  nf = FM.formatter(Int)
  println(FM.format(nf, 1234))
  nf2 = FM.formatter(Float64)
  println(FM.format(nf2, 1234))
end

@testset "Abstract factory pattern" begin
  button = AF.make_button("Click me")
end
