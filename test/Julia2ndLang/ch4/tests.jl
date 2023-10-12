using Test
using Statistics
using Random
import JuliaStudy.Julia2ndLang.JuliaAsASpreadsheet as JS

@testset "Julia as a spreadsheet" begin
  amounts = [4, 1, 5, 3, 2]
  row = [4 1 5 3 2]
  pizzas = [4 15.0;
    1 11.5;
    5 13.0;
    3 12.75;
    2 14.25]
  pizzas2 = [4 15.0; 1 11.5; 5 13.0; 3 12.75; 2 14.25]
  @test no_pizzas_sold = sum(amounts) == 15
  @test length(amounts) == 5
  @test avg = sum(amounts) / length(amounts) == 3

  prices = [15.0, 11.5, 13.0, 12.75, 14.25]
  sorted = sort(prices)
  @test sorted == [11.5, 12.75, 13.0, 14.25, 15.0]
  @test prices == [15.0, 11.5, 13.0, 12.75, 14.25]

  @test sort!(prices) == [11.5, 12.75, 13.0, 14.25, 15.0]
  @test prices == [11.5, 12.75, 13.0, 14.25, 15.0]

  prices = [15.0, 11.5, 13.0, 12.75, 14.25]
  prices_with_tax = prices * 1.25
  @test prices_with_tax == [18.75, 14.375, 16.25, 15.9375, 17.8125]
  @test_throws MethodError amounts*prices

  @test amounts .* prices == [60.0, 11.5, 65.0, 38.25, 28.5]
  @test sum(amounts .* prices) == 203.25

  @test mean(amounts) == 3.0
  @test mean(prices) == 13.3
  @test median(amounts) == 3.0
  @test median(prices) == 13.0
  @test std(amounts) == 1.5811388300841898
  @test std([3 3 3]) == 0.0

  amounts = [4, 1, 5, 3, 2]
  @test amounts[1] == 4
  @test amounts[2] == 1
  @test amounts[5] == 2
  @test_throws BoundsError amounts[0]

  xs = [2, 3]
  xs[1] = 42
  @test xs == [42, 3]
  xs[2] = 12
  @test xs == [42, 12]

  @test amounts[1] == amounts[begin]
  @test amounts[5] == amounts[end]
  @test amounts[4] == amounts[end - 1]
end

@testset "Creating Arrays" begin
  xs = zeros(50)
  @test length(xs) == 50
  @test ones(5) == [1.0, 1.0, 1.0, 1.0, 1.0]
  @test fill(42, 6) == [42, 42, 42, 42, 42, 42]
  Random.seed!(1234)
  @test rand(3) ==
        [0.32597672886359486, 0.5490511363155669, 0.21858665481883066]
  @test ones(Int8, 5) == [1, 1, 1, 1, 1]
  @test zeros(UInt8, 4) == [0, 0, 0, 0]
  Random.seed!(1234)
  xs = rand(Int8, 3)
  @test xs == [-79, 50, -24]
  @test eltype(xs) == Int8
  @test eltype([3, 4, 5]) == Int64
  @test eltype([true, false]) == Bool
end

@testset "Mapping values in an array " begin
  degs = [0, 30, 45, 60, 90]
  rads = map(deg2rad, degs)
  map(deg2rad, 0:15:90)
  map(sin, map(deg2rad, 0:15:90))

  result = zeros(Float64, length(0:15:90))
  map!(deg2rad, result, 0:15:90)
  map!(sin, result, result)
  degsin(deg) = sin(deg2rad(deg))
  map(degsin, 0:15:90)

  sin(1.0)
  g = sin
  @test g(1.0) == sin(1.0)
  add = +
  add(2, 3) == +(2, 3)
  ys = []
  @test push!(ys, 3) == [3]
  @test push!(ys, 8) == [3, 8]
  @test push!(ys, 2) == [3, 8, 2]

  x = Int8(65)
  @test Char(65) == 'A'
  @test Char(66) == 'B'
  @test Int8('A') == 65

  @test_throws MethodError 'A'+'B'
  @test 'A' + 3 == 'D'

  chars = ['H', 'E', 'L', 'L', 'O']
  @test join(chars) == "HELLO"
  @test join('A':'G') == "ABCDEFG"
  @test join('A':2:'G') == "ACEG"
  @test collect("HELLO") == ['H', 'E', 'L', 'L', 'O']

  @test collect(2:5) == [2, 3, 4, 5]
  @test 2:5 == [2, 3, 4, 5]
  @test collect('B':'D') == ['B', 'C', 'D']
end

@testset "Storing pizza data in tuples" begin
  pizza_tuple = ("hawaiian", 'S', 10.5)
  pizza_array = ["hawaiian", 'S', 10.5]
  @test eltype(pizza_array) == Any

  xs = [4, 5, 3]
  @test_throws MethodError xs[1]="hi"

  pizza = ["hawaiian", 'S', 10.5]
  pizza[3] = true
  pizza[1] = 42
  @test pizza == [42, 'S', true]

  pza = ("hawaiian", 'S', 10.5)
  @test typeof(pza) == Tuple{String, Char, Float64}
  @test pza[1] == "hawaiian"
  @test_throws MethodError pza[1]="pepperroni"

  for item in pza
    println(item)
  end

  nums = (3, 4, 1)
  @test sum(nums) == 8
  @test median(nums) == 3.0

  sales = [
    ("hawaiian", 'S', 10.5),
    ("sicilian", 'S', 12.25),
    ("hawaiian", 'L', 16.5),
    ("bbq chicken", 'L', 20.75),
    ("bbq chicken", 'M', 16.75),
  ]

  name(pizza) = pizza[1]
  portion(pizza) = pizza[2]
  price(pizza) = pizza[3]
  @test map(name, sales) ==
        ["hawaiian", "sicilian", "hawaiian", "bbq chicken", "bbq chicken"]
end

@testset "Filtering pizzzas based on predicates" begin
  @test iseven(3) == false
  @test iseven(2)
  @test isodd(3)
  @test isodd(4) == false
  @test isuppercase('A')
  @test isuppercase('a') == false
  @test isspace(' ')
  @test isspace('X') == false

  @test filter(iseven, 1:10) == [2, 4, 6, 8, 10]

  issmall(pizza) = portion(pizza) == 'S'
  islarge(pizza) = portion(pizza) == 'L'
  isbbq(pizza) = name(pizza) == "bbq chicken"

  @test filter(islarge, sales) == [
    ("hawaiian", 'L', 16.5),
    ("bbq chicken", 'L', 20.75),
  ]
  @test map(price, filter(islarge, sales)) == [16.5, 20.75]
  @test sum(map(price, filter(islarge, sales))) == 37.25
  bbq_sales = filter(isbbq, sales)
  @test bbq_sales == [
    ("bbq chicken", 'L', 20.75),
    ("bbq chicken", 'M', 16.75),
  ]
  @test sum(map(price, bbq_sales)) == 37.5
  @test mapreduce(price, +, bbq_sales) == 37.5

  mapcompress(f, g, xs) = reduce(g, map(f, xs))
  @test sum(2:4) == 9
  reduce(+, 2:4) == 9
  @test factorial(4) == 24
  @test reduce(*, 1:4) == 24

  matches = map(islarge, sales)
  @test sum(matches) == 2
  @test sum(islarge, sales) == 2
  @test sum(isbbq, sales) == 2
end
