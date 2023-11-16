using Test
import JuliaStudy.Julia2ndLang.StoringDataInDictionaries as StoD

@testset "Storing Data In Dictionaries" begin
  @test StoD.parse_roman("II") == 2
  @test StoD.parse_roman("IV") == 4
  @test StoD.parse_roman("IX") == 9
  @test StoD.parse_roman("XI") == 11

  'X' => 10
  pair = 'X' => 10
  dump(pair)
  @test pair.first == 'X'
  @test pair.second == 10

  range = 2:4
  pair2 = 8 => 9
  tuple = (3, 'B')
  @test map(first, [range, pair2, tuple]) == [2, 8, 3]
  @test map(last, [range, pair2, tuple]) == [4, 9, 'B']

  @test StoD.roman_numerals['C'] == 100
  @test StoD.roman_numerals['M'] == 1000

  Dict('A' + i => i for i in 1:4)

  enumerate([4, 6, 8])
  collect(2:3:11)
  collect(enumerate([4, 6, 8]))

  Dict("two" => 2, "four" => 4)
  pairs = ["two" => 2, "four" => 4]
  Dict(pairs)

  tuples = [("two", 2), ("four", 4)]
  Dict(tuples)

  pizzas = [
    ("mexicanna", 13.0),
    ("hawaiian", 16.5),
    ("bbq chicken", 20.75),
    ("sicilian", 12.25),
  ]

  pizza_dict = Dict(pizzas)
  @test pizza_dict["mexicanna"] == 13.0

  d = Dict()
  d2 = Dict{String, Float64}()
  d2["hawaiian"] = 16.5
  @test_throws MethodError d2[5]="five"

  words = ["one", "two"]
  nums = [1, 2]
  collect(zip(words, nums))
  Dict(zip(words, nums))

  @test_throws KeyError d["seven"]

  @test get(d, "eight", -1) == -1
  @test haskey(d, "eight") == false
  d["eight"] = 8
  @test haskey(d, "eight")

  @test StoD.lookup('X', StoD.numerals) == 10
  @test StoD.lookup('D', StoD.numerals) == 500
  @test_throws KeyError StoD.lookup('S', StoD.numerals)

  i = searchsortedfirst(StoD.keys, 'I')
  @test i == 3
  @test StoD.vals[i] == 1

  j = searchsortedfirst(StoD.keys, 'V')
  @test j == 6
  @test StoD.vals[j] == 5

  pizza_n = (name = "hawaiian", size = 'S', price = 10.5)
  @test pizza_n[:name] == "hawaiian"
  @test pizza_n[:price] == 10.5
  @test pizza_n[:size] == 'S'
  @test pizza_n.name == "hawaiian"
  @test pizza_n.size == 'S'

  s = "price"
  t = :name
  @test Symbol(s) == :price
  @test string(t) == "name"

  @test StoD.parse_roman2("II") == 2
  @test StoD.parse_roman2("IV") == 4
  @test StoD.parse_roman2("IX") == 9
  @test StoD.parse_roman2("XI") == 11
end
