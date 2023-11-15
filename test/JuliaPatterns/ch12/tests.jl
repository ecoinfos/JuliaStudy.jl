using Test
import JuliaStudy.JuliaPatterns.InheritanceAndVariance as InVa

@testset "Inheritance and Variance" begin
  car = InVa.Car()
  InVa.move(car)

  helicopter = InVa.Helicopter()
  InVa.move(helicopter)
  InVa.liftoff(helicopter)

  InVa.liftoff(helicopter)

  horse = InVa.Horse()
  InVa.move(horse)

  InVa.adopt(InVa.Cat("Felix"))
  InVa.adopt(InVa.Dog("Clifford"))

  @test_throws MethodError InVa.adopt(InVa.Crocodile("Solomon"))

  @test_throws MethodError InVa.adopt([
    InVa.Cat("Felix"),
    InVa.Cat("Garfield"),
  ])

  InVa.adopt(InVa.Mammal[InVa.Cat("Felix"), InVa.Cat("Garfield")])

  InVa.adopt2([InVa.Cat("Felix"), InVa.Cat("Garfield")])
  InVa.adopt2([InVa.Dog("Clifford"), InVa.Dog("Astro")])
  InVa.adopt2([InVa.Cat("Felix"), InVa.Dog("Clifford")])

  @test Tuple{InVa.Cat, InVa.Cat} <: Tuple{InVa.Mammal, InVa.Mammal}
  @test Tuple{InVa.Cat, InVa.Dog} <: Tuple{InVa.Mammal, InVa.Mammal}
  @test Tuple{InVa.Dog, InVa.Cat} <: Tuple{InVa.Mammal, InVa.Mammal}
  @test Tuple{InVa.Dog, InVa.Dog} <: Tuple{InVa.Mammal, InVa.Mammal}
  @test (Tuple{InVa.Cat, InVa.Crocodile} <: Tuple{InVa.Mammal, InVa.Mammal}) ==
        false

  @test all(isodd, [1, 2, 3, 4, 5]) == false
  @test typeof(isodd) <: Function
  typeof(isodd)

  @test isabstracttype(Function)
  @test typeof(println) <: Function
  @test_throws TypeError all(println, [1, 2, 3, 4, 5])

  @test InVa.myall(isodd, [1, 3, 5])
  @test InVa.myall(iseven, [2, 4, 6])
  @test_throws UndefVarError myall(println, [2, 4, 6])

  InVa.match(InVa.Dog("Astro"))
  InVa.match(InVa.Cat("Garfield"))

  InVa.meet_partner(InVa.match, InVa.Cat("Felix"))

  @test_throws UndefVarError InVa.meet_partner(InVa.neighbor, Cat("Felix"))

  InVa.meet_partner(InVa.buddy, InVa.Cat("Felix"))

  @test_throws MethodError InVa.meet_partner(InVa.buddy, InVa.Dog("Chef"))

  @test InVa.PredicateFunction{Number, Bool}(iseven)(1) == false
  @test InVa.PredicateFunction{Number, Bool}(iseven)(2)

  @test InVa.safe_all(InVa.PredicateFunction{Number, Bool}(iseven), [2, 4, 6])
  @test InVa.safe_all(InVa.PredicateFunction{Number, Bool}(iseven),
    [2, 4, 6, 7]) == false

  InVa.triple([1, 2, 3])
  InVa.triple(Real[1, 2, 3.0])
  InVa.triple2([1, 2, 3])
  InVa.triple2(Real[1, 2, 3.0])

  InVa.add([1, 2, 3], 1)
  InVa.add([1.0, 2.0, 3.0], 1.0)
  @test_throws MethodError InVa.add([1, 2, 3], 1.0)

  InVa.add(Signed[1, 2, 3], Int8(1))

  @test InVa.diagonal(1, 2) == Int
  @test InVa.diagonal(1.0, 2.0) == Float64
  @test_throws MethodError InVa.diagonal(1, 2.0)
  @test_throws MethodError InVa.diagonal(1::Real, 2.0::Real)

  @test InVa.not_diagonal([1, 2, 3], 4, 5) == Int64
  @test InVa.not_diagonal(Signed[1, 2, 3], 4, 5) == Signed

  @test InVa.mytypes1([1, 2, 3], 4) == Int64
  @test InVa.mytypes2([1, 2, 3], 4) == Int64

  @test InVa.mytypes1(Signed[1, 2, 3], 4) == Signed
  @test_throws UndefVarError InVa.mytypes2(Signed[1, 2, 3], 4)
end
