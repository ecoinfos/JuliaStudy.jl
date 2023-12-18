using Test
import JuliaStudy.Julia2ndLang.NothingDataStructure: Empty,
  f, Wagon, cargo, Person
import JuliaStudy.Julia2ndLang.NothingDataStructure as NDS
using Statistics

@testset "Using nothing in data structures" begin
  findfirst("hello", "hello world")
  findfirst("foo", "hello world")

  none = NDS.Nothing()
  @test none === NDS.nothing
  empty = Empty()
  none2 = Empty()
  @test empty === none2
  @test Empty() === Empty()
  @test Empty() !== NDS.Nothing()
  @test empty !== NDS.nothing

  findfirst("four", "one two three four")
  ans = findfirst("four", "one two three")
  typeof(ans)
  @test findfirst("four", "one two three") == Core.nothing
end

@testset "Parametric types" begin
  @test typeof(['A', 'B', 'D']) == Vector{Char}
  @test typeof(3:4) == UnitRange{Int64}
  @test typeof(0x3 // 0x4) == Rational{UInt8}
  IntRange = UnitRange{Int}
  FloatRange = UnitRange{Float64}
  IntRange(3, 5)
  FloatRange(3, 5)
  NumPair = Pair{Int, Float32}
  NumPair(3, 5)

  @test f(3) == 27
  @test f("hello ") == "hello hello hello "
  @test_throws MethodError f(0.42)

  @test String <: Union{Int64, String}
  @test Int64 <: Union{Int64, String}
  @test (Float64 <: Union{Int64, String}) == false
  @test Union{String, Int64} <: Union{Int64, String}

  train = Wagon(3, Wagon(4, Wagon(1, NDS.nothing)))
  @test cargo(train) == 8
  @test_throws MethodError Wagon(3, Wagon(4, Wagon(1, 42)))
end

@testset "Missing Data" begin
  missing < 10
  @test_throws MethodError nothing<10
  10 + missing
  @test_throws MethodError 10+nothing

  xs = [2, missing, 4, 8]
  sum(xs)
  @test sum(skipmissing(xs)) == 14
  @test median(skipmissing(xs)) == 4.0
  @test mean(skipmissing(xs)) == 4.666666666666667
  0 / 0
  1 / 0
  -1 / 0
  NaN + 10
  NaN / 4
  @test (NaN < 10) == false
  @test (NaN > 10) == false
  calc(x) = 3x / x
  calc(0)
  calc(NaN)
end

@testset "Undefined Data" begin
  friend = Person()
  @test_throws UndefRefError friend.firstname
end
