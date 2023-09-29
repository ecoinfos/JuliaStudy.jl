using Test
using JuliaStudy
import JuliaStudy.JuliaPatterns.MemorizationPattern as MP
using JuliaStudy.JuliaPatterns.MemorizationPattern: read_csv
using Memoize
using Caching
using BenchmarkTools

PROJECT_ROOT = pkgdir(JuliaStudy)
# PROJECT_ROOT = dirname(Base.active_project())
CURRENT_SRC = "test/JuliaPatterns/ch6/"
SRC_DIR = joinpath(PROJECT_ROOT, CURRENT_SRC)

@testset "Fibonacci function" begin
  @test MP.fib.(1:10) == Vector{Int64}([1, 1, 2, 3, 5, 8, 13, 21, 34, 55])
  @test MP.fib2(6) == (result = 8, counter = 15)
  @test MP.fib2(10) == (result = 55, counter = 109)
  @test MP.fib2(20) == (result = 6765, counter = 13529)

  @btime MP.fib(40)

  @btime MP.fib3(40)

  MP.fib4(6)
  MP.fib4(5)
  MP.fib4(10)
  MP.fib4(40)
  MP.fib4(100)

  @btime MP.fib4(40)

  @time MP.op(2, 2, d = 5)
  @time MP.op(2, 2, d = 5)
  @time MP.op(1, 2, c = 4, d = 5)
  @time MP.op(1, 2, c = 4, d = 5)

  x = [1, -2, 3, -4, 5]
  @time MP.sum_abs(x)
  @time MP.sum_abs(x)

  push!(x, -6)
  @time MP.sum_abs(x)
  @time MP.sum_abs(x)

  push!(x, 7)
  @time MP.sum_abs(x)
  @time MP.sum_abs(x)

  x = [1, -2, 3, -4, 5]
  for i in 6:10
    push!(x, i * (iseven(i) ? -1 : 1))
    ts = @elapsed val = MP.sum_abs2(x)
    println(i, ": ", x, " -> ", val, " (", round(ts, digits = 1), "s)")
    ts = @elapsed val = MP.sum_abs2(x)
    println(i, ": ", x, " -> ", val, " (", round(ts, digits = 1), "s)")
  end

  @memoize fib5(n) = n < 3 ? 1 : fib5(n - 1) + fib5(n - 2)
  @time fib5(40)
  @time fib5(40)
  @time fib5(39)

  df = MP.read_csv(SRC_DIR * "Film_Permits.csv")
  @test size(df) == (13630, 14)

  df_again = MP.read_csv(SRC_DIR * "Film_Permits.csv")
  @test df == df_again

  # propertynames(@cache read_csv)
  dc = @cache read_csv "/tmp/diskcash.bin"
  dc.cache
  dc.filename
  @persist! dc
  dc
  @empty! dc

  df2 = MP.read_csv(SRC_DIR * "Film_Permits.csv")
  size(df2)
  dc
  @syncache! dc "disk"
  @test isfile("/tmp/diskcash.bin") == true
  @empty! dc true
  @test isfile("/tmp/diskcash.bin") == false
end
