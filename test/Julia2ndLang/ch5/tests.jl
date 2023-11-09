using Test
import JuliaStudy.Julia2ndLang.WorkingWithText as WW

@testset "Working With Text" begin
  println("Hello world")
  print("Hello world")
  println("Hello")
  println("world")
  print("Hello")
  print("world")
  print("Hello\n")
  print("world\n")

  newln = Char(0x0a)
  print("hi")
  print(newln)
  print("world")

  println("hello \v world")
  println("hello \n world")
  println("hello \r world")
  println("ABC\n\tABC\n\tABC")

  print("\u001b[33m hello world")

  printstyled("hello world", color = :cyan)

  sym = Symbol("hello")
  @test sym == :hello

  print("abc", 42, true, "xyz")
  string("abc", 42, true, "xyz")

  pizza = ("hawaiian", 'S', 10.5)
  println(WW.name(pizza), " ", WW.portion(pizza), " ", WW.price(pizza))

  pizzas = [
    ("hawaiian", 'S', 10.5),
    ("mexicana", 'S', 13.0),
    ("hawaiian", 'L', 16.5),
    ("bbq chicken", 'L', 20.75),
    ("sicilian", 'S', 12.25),
    ("bbq chicken", 'M', 16.75),
    ("mexicana", 'M', 16.0),
    ("thai chicken", 'L', 20.75),
  ]

  for pz in pizzas
    println(WW.name(pz), " ", WW.portion(pz), " ", WW.price(pz))
  end

  lpad("ABC", 6, '-')
  rpad("ABC", 6, '-')

  length("thai chicken")
  length("size")
  max(length("16.75"), length("price"))

  WW.simple_pizzatable(pizzas)
end

@testset "Adding lines" begin
  @test Char(0x2502) == '│'
  @test '\U2502' == '│'
  collect("─├┼┤")
  @test "A2"^3 == "A2A2A2"
  @test "-"^4 == "----"
  @test '-'^4 == "----"
  @test "─"^2 == "──"
  @test '─'^2 == "──"

  rads = map(deg2rad, 0:15:90)
  map(sin, rads)

  WW.format(3.1)
  WW.format(-3.1)
  lpad(WW.format(4.2), 6)
  lpad(WW.format(-4.2), 6)
  WW.print_trigtable(5, 90)

  pizzas = [
    ("hawaiian", 'S', 10.5),
    ("mexicana", 'S', 13.0),
    ("hawaiian", 'L', 16.5),
    ("bbq chicken", 'L', 20.75),
    ("sicilian", 'S', 12.25),
    ("bbq chicken", 'M', 16.75),
    ("mexicana", 'M', 16.0),
    ("thai chicken", 'L', 20.75),
  ]
  WW.store_pizzatable(stdout, pizzas[1:3])

  io = open("/tmp/pizza-sales.csv", "w")
  WW.store_pizzatable(io, pizzas)
  close(io)
  run(`cat /tmp/pizza-sales.csv`)

  io = open("/tmp/pizza-sales.csv")
  line = readline(io)
  line = readline(io)

  # s = readline(stdin)
  # print(s)

  pizza = split(line, ',')
  p = WW.price(pizza)
  @test_throws MethodError p*1.25
  @test typeof(p) == SubString{String}

  @test parse(Int, "42") == 42
  @test parse(Float64, "42") == 42.0
  @test parse(Bool, "true") == true
  @test parse(Bool, "1") == true
  @test parse(Bool, "0") == false

  pizzas = WW.load_pizzatable(io)
  close(io)

  # WW.practice(8)
  x = rand(2:9)
  y = rand(2:9)
end
