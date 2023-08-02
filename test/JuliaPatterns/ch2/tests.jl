using Test
using JuliaStudy.JuliaPatterns
using JuliaStudy.JuliaPatterns.Calculator
using JuliaStudy.JuliaPatterns.DataTypeConcepts
using InteractiveUtils

@testset "Calculator" begin
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
    @test rate(3, 1)≈0.33 rtol=1e-2
  end
end

@testset "DataTypeConcepts" begin
  @testset "Type Hierarchy" begin
    @test subtypes(Asset) == Any[Cash, Investment, Property]
    @test subtypes(Asset) == Any[DataTypeConcepts.Cash,
      DataTypeConcepts.Investment,
      DataTypeConcepts.Property]
    @test supertype(Equity) == Investment
  end
end

@testset "Subtypetree" begin
  @test subtypeTreeStr() == ""
  @test subtypeTreeStr(House) == "House"
  @test subtypeTreeStr(Apartment) == "Apartment"
  @test subtypeTreeStr(Cash) == "Cash"

  indent = 2

  expected = "Property" *
             "\n" * join(fill(" ", indent)) * "Apartment" *
             "\n" * join(fill(" ", indent)) * "House"
  @test subtypeTreeStr(Property, indent) == expected

  expected = "Investment" *
             "\n" * join(fill(" ", indent)) * "Equity" *
             "\n" * join(fill(" ", 2 * indent)) * "Stock" *
             "\n" * join(fill(" ", 2 * indent)) * "muStock" *
             "\n" * join(fill(" ", indent)) * "FixedIncome"
  @test subtypeTreeStr(Investment, indent) == expected

  expected = "Asset" *
             "\n" * join(fill(" ", indent)) * "Cash" *
             "\n" * join(fill(" ", indent)) * "Investment" *
             "\n" * join(fill(" ", 2 * indent)) * "Equity" *
             "\n" * join(fill(" ", 3 * indent)) * "Stock" *
             "\n" * join(fill(" ", 3 * indent)) * "muStock" *
             "\n" * join(fill(" ", 2 * indent)) * "FixedIncome" *
             "\n" * join(fill(" ", indent)) * "Property" *
             "\n" * join(fill(" ", 2 * indent)) * "Apartment" *
             "\n" * join(fill(" ", 2 * indent)) * "House"
  @test subtypeTreeStr(Asset, indent) == expected
end

# immutable fixture
apple = Stock("AAPL", "Apple, Inc.")
ibm = Stock("IBM", "IBM")
# mutable fixture
get_mu_apple() = muStock("AAPL", "Apple, Inc.")

@testset "Desing Concreate Types" begin
  @test describe(apple) == "AAPL(Apple, Inc.)"
  # immutable field cannot be changed.
  @test_throws ErrorException apple.name="Apple LLC"

  many_stocks = [apple, ibm]
  basket = BasketOfStocks(many_stocks, "Anniversary gift for my wife")
  @test pop!(basket.stocks) == ibm
  @test many_stocks[1] == apple

  mu_apple = get_mu_apple()
  mu_apple.name = "Apple LLC"
  @test mu_apple.name == "Apple LLC"

  monalisa = Painting("Leonardo da Vinci", "Monalisa")
  things = Union{Painting, Stock}[apple, monalisa]
  present = BasketOfThings(things, "Anniversary gift for my wife")
  new_present = newBasketOfThings(things, "Anniversary gift for my wife")
  @test present.things == new_present.things
end

@testset "Working with type operator" begin
  @test 1 isa Int
  @test !(1 isa Float64)
  @test 1 isa Real
  @test Int <: Real
end

@testset "Working with parametric composite types" begin
  holding1 = StockHolding(apple, 100)
  holding2 = StockHolding(apple, 100.00)
  holding3 = StockHolding(apple, 100 // 3)
  # Not defined for String
  @test_throws MethodError StockHolding(apple, "100")

  holding4 = StockHolding2(apple, 100, 180.00, 18000.00)
  # Not defined for different type of price and marketvalue.
  @test_throws MethodError StockHolding2(apple, 100, 180, 18000.00)

  @test StockHolding3{Int64, Float64} <: Holding{Float64}
  certificate_in_the_safe = StockHolding3(apple, 100, 180.00, 18000.00)
  @test certificate_in_the_safe isa Holding{Float64}
  @test Holding{Float64} <: Holding
  @test Holding{Int} <: Holding
  @test !(Holding{Float64} <: Holding{Int})
  @test !(Holding{Int} <: Holding{Float64})
end

@testset "Conversion between data types" begin
  @test Float64(1 // 3) ≈ convert(Float64, 1 // 3)
  @test convert(Rational, convert(Float64, 1 // 3)) != 1 // 3
  @test convert(Int64, convert(Float64, 2^53 + 1)) != 2^53 + 1
  @test convert(Int64, convert(BigFloat, 2^53 + 1)) == 2^53 + 1

  x = rand(3)
  x[1] = 1
  @test x[1] == 1.0
  @test x[1] isa Float64
  @test !(x[1] isa Int)

  mutable struct Foo
    x::Float64
  end
  foo = Foo(1.0)
  foo.x = 2
  @test foo.x isa Float64

  struct Bar
    x::Float64
    Bar(v) = new(v)
  end
  bar = Bar(1)
  @test bar.x isa Float64

  function roo()
    local x::Float64
    x = 1
    typeof(x)
  end
  @test roo() == Float64

  function goo()::Float64
    return 1
  end
  @test goo() == 1.0

  # Not work
  # ccall((:exp, "libc"), Float64, (Float64,), 2)

  # print(subtypeTreeStr(AbstractFloat, 2))
  twice(x::AbstractFloat) = 2x
  @test twice(1.0) == 2.0
  # BigFloat("1.5e1234")
  @test_throws MethodError twice(2)

  twice_general(x) = 2x
  @test twice_general(1.0) == 2.0
  @test twice_general(1) == 2

  twice_number(x::Number) = 2x
  @test twice_number(1.0) == 2.0
  @test twice_number(1) == 2
  @test twice_number(2 // 3) == 4 // 3
end
