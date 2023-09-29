using Test
import JuliaStudy.JuliaPatterns.DelegationPattern as DP
import JuliaStudy.JuliaPatterns.HolyTraitsPattern as HT
import JuliaStudy.JuliaPatterns.ParametricTypePattern as PT

using Lazy: @forward
using OffsetArrays
using Random, Dates, NamedDims

@testset "Delegation Pattern" begin
  @macroexpand @forward SavingsAccount.acct balance, deposit!

  y = OffsetArray(rand(3), 0:2)
  y[0:2]
end

@testset "Holy Traits Pattern" begin
  cash = HT.Money("USD", 100.00)
  @test HT.tradable(cash)
  @test HT.marketprice(cash) == 100.00

  # Without qualifier, Stock is from ch2/DataTypeConcepts.jl
  aapl = HT.Stock("AAPL", "Apple, Inc.")
  @test HT.tradable(aapl)
  Random.seed!(1234)
  @test HT.marketprice(aapl) == 216

  home = HT.Residence("Los Angeles")
  @test HT.tradable(home) == false
  @test_throws ErrorException HT.marketprice(home)

  bill = HT.TreasuryBill("123456789")
  @test HT.tradable(bill)
  @test_throws ErrorException HT.marketprice(bill)

  mybook = HT.Book("Shape")
  @test HT.tradable(mybook)
  @test HT.marketprice(mybook) == 10.0

  collect(Iterators.take(Iterators.repeated(1), 5))
  @test Base.IteratorSize(Iterators.repeated(1)) == Base.IsInfinite()

  BitArray([isodd(x) for x in 1:5])
  @test_throws ArgumentError BitArray(Iterators.repeated(1))

  @test_throws ErrorException HT.marketprice2(HT.Residence("Los Angeles"))

  @test HT.marketprice2(aapl) == 123
end

@testset "Parametric Type Pattern" begin
  stock = PT.Stock("AAPL", "Apple Inc.")
  option = PT.StockOption("AAPLC", PT.Call, 200, Date(2019, 12, 20))
  PT.SingleTrade(PT.Long, stock, 100, 188.0)
  PT.SingleTrade(PT.Long, option, 100, 3.5)

  @test PT.SingleTrade{PT.Stock} <: PT.SingleTrade
  @test PT.SingleTrade{PT.StockOption} <: PT.SingleTrade
  @test PT.SingleTrade(PT.Long, stock, 100, 188.0) |> PT.payment == 18800.0
  @test PT.SingleTrade(PT.Long, option, 1, 3.50) |> PT.payment == 350.0

  pt = PT.PairTrade(PT.SingleTrade(PT.Long, stock, 100, 188.0),
    PT.SingleTrade(PT.Short, option, 1, 3.5))
  @test PT.payment(pt) == 18450.0

  M = PT.reshape(collect(1:9), 3, 3)
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
