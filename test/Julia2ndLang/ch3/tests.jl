using Test
import JuliaStudy.Julia2ndLang.ControlFlow as CF
import JuliaStudy.Julia2ndLang.TrigCh3 as TG

@testset "Boolean expressions" begin
  @test (3 > 5) == false
  @test (8 > 3) == true
  @test 8 == 5 + 3
  @test (3 == 5) == false
  @test 3 ≤ 3
  @test 3 <= 3

  @test typeof(7 > 3) == Bool
  @test typeof(false) == Bool
  @test reinterpret(UInt8, false) == 0x00
  @test reinterpret(Int8, false) == 0x00
  @test reinterpret(UInt8, true) == 0x01
  @test reinterpret(Int8, true) == 0x01

  @test true + true == 2
  # @test 3true + true == 4
  @test 3 * true + true == 4
  @test true + false + true == 2
  @test false + false == 0
end

@testset "Compound statement" begin
  x = 3
  @test (x < 4 || x > 10)
  x = 5
  @test (x < 4 || x > 10) == false
  @test x > 4 && x < 10
  x = 12
  @test (x > 4 && x < 10) == false
end

@testset "Looping" begin
  x = 4
  y = 8
  z = 3
  @test [x, y, z] == [4, 8, 3]

  x = 3 + 4
  y = while false
  end
  @test typeof(y) == Nothing
  @test (z = 3 + 2) == 5

  i = 0
  while i < 5
    i = i + 1
    print(i)
  end

  i = 0
  while i < 5
    i = i + 1
    println(i)
  end
end

@testset "Make a mathematical table for the sine function" begin
  angle = 0
  while angle <= 90
    println(angle)
    angle = angle + 15
  end

  angle = 0
  while angle <= 90
    rad = CF.deg2rad(angle)
    x = sin(rad)
    println(x)
    angle = angle + 15
  end
end

@testset "Range object" begin
  r = 2:4
  @test first(r) == 2
  @test last(r) == 4
  @test in(1, r) == false
  @test in(3, r)
  @test 3 in r
end

@testset "For loops" begin
  i = 0
  while i in 0:4
    println(i)
    i = i + 1
  end

  for i in 0:4
    println(i)
  end

  for angle in 0:15:90
    println(angle)
  end
end

@testset "Multiline functions" begin
  CF.print_sin_table(1, 90)
  @test TG.sine(0.5) ≈ 0.479425538604203
  @test sin(0.5) ≈ 0.479425538604203
  @test TG.sine(1.0) ≈ 0.841470984807897
  @test sin(1.0) ≈ 0.841470984807897

  @test TG.fac(5) == 120
  @test TG.fac(5) == factorial(5)

  @test TG.fac2(5) == 120

  fac3(n) = n * fac3(n - 1)
  @test_throws StackOverflowError fac3(5)

  @test TG.fac4(5) == 120

  @test TG.fac5(5) == 120

  x = 4
  y = if x > 3
    6
  else
    4
  end
  @test y == 6

  @test factorial(0) == 1
  @test_throws DomainError factorial(-1)

  @test TG.fac5(0) == 0
  @test TG.fac5(-1) == -1

  @test TG.fac6(5) == 120
  @test TG.fac6(0) == 1
  @test_throws DomainError TG.fac6(-1)

  y = try
    TG.fac6(3)
  catch e
    42
  end
  @test y == 6

  y = try
    TG.fac6(-3)
  catch e
    42
  end
  @test y == 42
end

@testset "Fibonacci number" begin
  @test CF.fib(3) == CF.fib(2) + CF.fib(1)
  @test CF.fib(4) == CF.fib(3) + CF.fib(2)
  @test CF.fib(5) == CF.fib(4) + CF.fib(3)

  @test CF.fib2(3) == CF.fib2(2) + CF.fib2(1)
  @test CF.fib2(4) == CF.fib2(3) + CF.fib2(2)
  @test CF.fib2(5) == CF.fib2(4) + CF.fib2(3)

  @test CF.fibi(3) == CF.fibi(2) + CF.fibi(1)
  @test CF.fibi(4) == CF.fibi(3) + CF.fibi(2)
  @test CF.fibi(5) == CF.fibi(4) + CF.fibi(3)
  CF.fibi(30)
  CF.fib2(40)   # a bit slow
  CF.fibi(40)
end
