using Test
using JuliaStudy.JuliaPatterns.DelegationPattern
using JuliaStudy.JuliaPatterns.HolyTraitsPattern
using JuliaStudy.JuliaPatterns.ParametricTypePattern

using Lazy: @forward
using OffsetArrays
using Random, Dates, NamedDims

@testset "Delegation Pattern" begin
  @macroexpand @forward SavingsAccount.acct balance, deposit!

  y = OffsetArray(rand(3), 0:2)
  y[0:2]
end

@testset "Holy Traits Pattern" begin
  cash = Money("USD", 100.00)
  @test tradable(cash)
  @test marketprice(cash) == 100.00

  # Without qualifier, Stock is from ch2/DataTypeConcepts.jl
  aapl = HolyTraitsPattern.Stock("AAPL", "Apple, Inc.")
  @test tradable(aapl)
  Random.seed!(1234)
  @test marketprice(aapl) == 216

  home = Residence("Los Angeles")
  @test tradable(home) == false
  @test_throws ErrorException marketprice(home)

  bill = TreasuryBill("123456789")
  @test tradable(bill)
  @test_throws ErrorException marketprice(bill)

  mybook = Book("Shape")
  @test tradable(mybook)
  @test marketprice(mybook) == 10.0

  collect(Iterators.take(Iterators.repeated(1), 5))
  @test Base.IteratorSize(Iterators.repeated(1)) == Base.IsInfinite()

  BitArray([isodd(x) for x in 1:5])
  @test_throws ArgumentError BitArray(Iterators.repeated(1))

  @test_throws ErrorException marketprice2(Residence("Los Angeles"))

  @test marketprice2(aapl) == 123
end

@testset "Parametric Type Pattern" begin
  stock = ParametricTypePattern.Stock("AAPL", "Apple Inc.")
  option = StockOption("AAPLC", Call, 200, Date(2019, 12, 20))
  SingleTrade(Long, stock, 100, 188.0)
  SingleTrade(Long, option, 100, 3.5)

  @test SingleTrade{ParametricTypePattern.Stock} <: SingleTrade
  @test SingleTrade{ParametricTypePattern.StockOption} <: SingleTrade
  @test SingleTrade(Long, stock, 100, 188.0) |> payment == 18800.0
  @test SingleTrade(Long, option, 1, 3.50) |> payment == 350.0

  pt = PairTrade(SingleTrade(Long, stock, 100, 188.0),
    SingleTrade(Short, option, 1, 3.5))
  @test payment(pt) == 18450.0

  M = reshape(collect(1:9), 3, 3)
  nda = NamedDimsArray{(:x, :y)}(M)
  @test dimnames(nda) == (:x, :y)
  @test NamedDimsArray{(:x, :y), Int64, Array{Int64, 2}} <:
        NamedDimsArray{(:x, :y)}
  @test (NamedDimsArray{(:x, :y), Int64, Array{Int64, 2}} <:
         NamedDimsArray{(:a, :b)}) == false
  NamedDimsArray{(:x, :y)}
  NamedDimsArray{
    (:x, :y),
    T,
    N,
    A,
  } where {A <: AbstractArray{T, N}} where {N} where {T}
  NamedDimsArray{
    L,
    T,
    N,
    A,
  } where {A <: AbstractArray{T, N}} where {N} where {T} where {L}
end
