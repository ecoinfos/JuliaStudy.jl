using Test
using Distributed, SharedArrays
@everywhere using JuliaStudy
using JuliaStudy.JuliaPatterns.GlobalConstantPattern
using JuliaStudy.JuliaPatterns.StructOfArraysPattern
@everywhere using JuliaStudy.JuliaPatterns.SharedArrayPattern

@everywhere using Statistics: std, mean, median
@everywhere using StatsBase: skewness, kurtosis

using BenchmarkTools
@everywhere using Statistics: std
using StructArrays

using JuliaStudy.JuliaPatterns.MemorizationPattern
using Memoize

variable = 10
@testset "The Global Constant Pattern" begin
  @btime add_using_global_variable(10)

  @btime add_using_function_args(10, 10)

  @code_llvm add_using_function_args(10, 10)
  @code_llvm add_using_global_variable(10)

  @btime add_using_global_constant(10)
  @code_llvm add_using_global_constant(10)

  @btime add_using_global_variable_typed(10)

  @code_typed constant_folding_example()

  @btime add_by_passing_global_variable(10, $variable)
  @btime add_by_passing_global_variable(10, variable)

  Ref(10)
  Ref("abc")

  @btime add_using_global_semi_constant(10)
end

PROJECT_ROOT = pkgdir(JuliaStudy)
CURRENT_SRC = "test/JuliaPatterns/ch6/"
SRC_DIR = joinpath(PROJECT_ROOT, CURRENT_SRC)
records = read_trip_payment_file(SRC_DIR *
                                 "yellow_tripdata_2018-12_100k.csv")
fare_amounts = [r.fare_amount for r in records]
columar_records = TripPaymentColumnarData([r.VendorID for r in records],
  [r.tpep_pickup_datetime for r in records],
  [r.tpep_dropoff_datetime for r in records],
  [r.passenger_count for r in records],
  [r.trip_distance for r in records],
  [r.fare_amount for r in records],
  [r.extra for r in records],
  [r.mta_tax for r in records],
  [r.tip_amount for r in records],
  [r.tolls_amount for r in records],
  [r.improvement_surcharge for r in records],
  [r.total_amount for r in records])
sa = StructArray(records)

records2 = read_trip_payment_file2(SRC_DIR *
                                   "yellow_tripdata_2018-12_100k.csv")

@testset "The struct of arrays pattern" begin
  @test mean(r.fare_amount for r in records) ≈ 13.142950
  @btime mean(r.fare_amount for r in records)

  @btime mean(fare_amounts)

  @btime mean(columar_records.fare_amount)

  sa[1:3]
  sa[1]
  typeof(sa[1])
  sa.fare_amount

  @btime mean(sa.fare_amount)

  Base.summarysize(records) / 1024 / 1024
  Base.summarysize(sa) / 1024 / 1024

  # records = nothing
  # GC.gc()

  records2[1]
  sa2 = StructArray(records2)
  sa2[1]
  @test_throws ErrorException sa2.fare.fare_amount
  sa3 = StructArray(records2, unwrap = t -> t <: Fare)
  sa3[1]
  sa3.fare.fare_amount
end

folder = joinpath("/tmp/" * "julia_book_ch06_data")
@testset "The shared array pattern" begin
  locate_file.(vcat(1:2, 100:101))

  make_data_directories(folder)
  cd(folder)
  generate_test_data(100_000)

  addprocs(16)
  # addprocs(16; exeflags = `--project=$(Base.active_project())`)
  rmprocs(18:49)
  @test nworkers() == 16
  @everywhere folder = joinpath("/tmp/" * "julia_book_ch06_data")
  @everywhere cd(folder)
  @everywhere cd(joinpath("/tmp/" * "julia_book_ch06_data"))

  nfiles = 100_000
  nstates = 10_000
  nattr = 3
  valuation = SharedArray{Float64}(nstates, nattr, nfiles)
  @btime load_data!(nfiles, valuation)
  @benchmark std_by_security($valuation) seconds=30
  result = std_by_security(valuation)
  result[1:5, :]
  @test size(result) == (100_000, 3)

  result2 = std_by_security2(valuation)
  @benchmark std_by_security2($valuation) seconds=30

  funcs = (std, skewness, kurtosis)
  @time result = stats_by_security(valuation, funcs)

  @time result = stats_by_security2(valuation, funcs)
end

@testset "Shared Array" begin
  A = SharedArray{Float64}(10_000, 10_000)
  A[:] = rand(10_000, 10_000)
  varinfo(Main, r"A")

  @everywhere struct Point{T <: Real}
    x::T
    y::T
  end

  A = SharedArray{Point{Float64}}(3)
  A .= [Point(rand(), rand()) for in in 1:length(A)]

  @everywhere mutable struct MutablePoint{T <: Real}
    x::T
    y::T
  end
  B = SharedArray{MutablePoint{Float64}}(3)
end

@testset "Fibonacci function" begin
  @test fib.(1:10) == Vector{Int64}([1, 1, 2, 3, 5, 8, 13, 21, 34, 55])
  @test fib2(6) == (result = 8, counter = 15)
  @test fib2(10) == (result = 55, counter = 109)
  @test fib2(20) == (result = 6765, counter = 13529)

  @btime fib(40)

  @btime fib3(40)

  fib4(6)
  fib4(5)
  fib4(10)
  fib4(40)
  fib4(100)

  @btime fib4(40)

  @time op(2, 2, d = 5)
  @time op(2, 2, d = 5)
  @time op(1, 2, c = 4, d = 5)
  @time op(1, 2, c = 4, d = 5)

  x = [1, -2, 3, -4, 5]
  @time sum_abs(x)
  @time sum_abs(x)

  push!(x, -6)
  @time sum_abs(x)
  @time sum_abs(x)

  push!(x, 7)
  @time sum_abs(x)
  @time sum_abs(x)

  x = [1, -2, 3, -4, 5]
  for i in 6:10
    push!(x, i * (iseven(i) ? -1 : 1))
    ts = @elapsed val = sum_abs2(x)
    println(i, ": ", x, " -> ", val, " (", round(ts, digits = 1), "s)")
    ts = @elapsed val = sum_abs2(x)
    println(i, ": ", x, " -> ", val, " (", round(ts, digits = 1), "s)")
  end

  @memoize fib5(n) = n < 3 ? 1 : fib5(n - 1) + fib5(n - 2)
  @time fib5(40)
  @time fib5(40)
  @time fib5(39)

  df = read_csv(SRC_DIR * "Film_Permits.csv")
  @test size(df) ==(13630, 14)

  df_again  = read_csv(SRC_DIR * "Film_Permits.csv")
  @test df == df_again

  propertynames(read_csv)
  read_csv.cache
  read_csv.filename
  @persist! read_csv
  read_csv
  @empty! read_csv
  
  df2 = read_csv(SRC_DIR * "Film_Permits.csv")
  size(df2)
  read_csv
  @syncache! read_csv "disk"
end
