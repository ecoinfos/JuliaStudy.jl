using Test
using JuliaStudy.JuliaPatterns.MecrosAndMetaprogramming
using DataFrames

@testset "Metaprogramming basic" begin
  @time sum(rand(10_000_000))

  mycode() = sum(rand(10_000_000))
  timeit(mycode)

  seq = tuple(1:3...)
  hello(seq)
  @code_lowered(hello(seq))

  Meta.parse("x + y")
  Meta.parse("x + y") |> typeof
  Meta.parse("x + y") |> dump
  Meta.parse("x") |> dump
  Meta.parse("""open("/tmp/test.txt", read=true, write=true)""") |> dump
  Meta.parse("cos(sin(x+1))") |> dump

  Expr(:call, :+, :x, :y)
  @test string(Meta.parse("x + y")) == string(Expr(:call, :+, :x, :y))
  Expr(:call, :sin, Expr(:call, :+, :x, :y))

  ex = :(x + y)
  dump(ex)

  :(begin
    x = 1
    y = 2
  end)

  quote
    x = 1
    y = 2
  end

  :(x = 1 + 1) |> dump

  :(begin
    println("hello")
    println("world")
  end) |> dump

  :(if 2 > 1
    "good"
  else
    "bad"
  end) |> dump

  :(for i in 1:5
    println("Hello world")
  end) |> dump

  :(function foo(x; y = 1)
    return x + y
  end) |> dump

  eval(:(x = 1))
  # x

  function foo()
    eval(:(y = 1))
  end

  foo()
  @test y == 1   # y is in global scope

  x = 2
  :(sqrt($x))

  v = [1, 2, 3]
  quote
    max($(v...))
  end

  quote
    max($v...)
  end

  :(x = y) |> dump

  :(x = :hello) |> dump
  sym = QuoteNode(:hello)
  :(x = $sym)

  sym2 = :hello
  :(x = $sym2)

  :(x = 1 + 1) |> dump
  :(:(x = 1)) |> dump

  v = 2
  :(:(x = $v)) |> dump
  :(:(x = $($v))) |> dump
end

function showme(x)
  @show x
end

macro showme(x)
  @show x
end

function foo2()
  return @identify 1 + 2 + 3
end

macro squared(ex)
  return :($(ex) * $(ex))
end

function foo3()
  x = 2
  return @squared x
end

macro squared2(ex)
  return :($(esc(ex)) * $(esc(ex)))
end

function foo4()
  x = 2
  return @squared2 x
end

function foo5()
  times = 0
  @ntimes 3 println("Hello world")
  println("times = ", times)
end

@testset "Developing Macros" begin
  @hello()
  @hello
  @hello(2)
  @hello 2

  a = 1
  b = "hello"
  c = :hello

  showme(a)
  showme(b)
  showme(c)

  # @showme(a)
  # @showme(b)
  # @showme(c)

  @macroexpand @hello 2

  @code_lowered foo2()

  @squared 3

  foo3()
  @code_lowered foo3()

  foo4()

  @code_lowered foo4()

  :(sin(x)) |> dump
  :(sin(sin(x))) |> dump

  @test @compose_twice(sin(1)) == sin(sin(1))

  foo5()
  @macroexpand(@ntimes 3 println("Hello world"))

  typeof(r"^hello")

  DataFrame(x1 = rand(Float64, 100000), x2 = rand(Int16, 100000))

  ndf"100000:f64,f32,i16,i8"
end

@testset "Using generated functions" begin
  @doubled 3

  doubled(2)
  doubled2(2)
  doubled2(3.0)
  
end
