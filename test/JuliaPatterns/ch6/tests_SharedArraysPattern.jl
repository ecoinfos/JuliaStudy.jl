using Test
using JuliaStudy.JuliaPatterns.SharedArrayPattern
using Distributed, SharedArrays
using BenchmarkTools
using InteractiveUtils

test_data_folder = joinpath("/tmp/" * "julia_book_ch06_data")
@testset "Generate Test Data" begin
  locate_file.(vcat(1:2, 100:101))

  make_data_directories(test_data_folder)
  cd(test_data_folder)
  generate_test_data(1_000)
end

addprocs(16)
@everywhere using JuliaStudy
@everywhere using JuliaStudy.JuliaPatterns.SharedArrayPattern
@everywhere using Statistics: std, mean, median
@everywhere using StatsBase: skewness, kurtosis
nfiles = 1_000
nstates = 10_000
nattr = 3
valuation = SharedArray{Float64}(nstates, nattr, nfiles)
@testset "The shared array pattern" begin
  @test nworkers() == 16
  # addprocs(16; exeflags = `--project=$(Base.active_project())`)
  # rmprocs(18:49)
  # everywhere should be run after processes was created

  @everywhere test_data_folder = joinpath("/tmp/" * "julia_book_ch06_data")
  @everywhere cd(test_data_folder)

  @btime load_data!(nfiles, valuation)

  @benchmark std_by_security($valuation) seconds=30
  result = std_by_security(valuation)
  result[1:5, :]
  @test size(result) == (1_000, 3)

  result2 = std_by_security2(valuation)
  @benchmark std_by_security2($valuation) seconds=30

  funcs = (std, skewness, kurtosis)
  @time result = stats_by_security(valuation, funcs)

  @time result = stats_by_security2(valuation, funcs)
end
# Teardown process
rm(test_data_folder, recursive = true)
proc_list = procs()
# Get all worker processes except host process(= 1)
filter!(e -> e != 1, proc_list)
rmprocs(proc_list)

@testset "Shared Array" begin
  A = SharedArray{Float64}(10_000, 10_000)
  A[:] = rand(10_000, 10_000)
  varinfo(Main, r"A")

  @everywhere struct ShPoint{T <: Real}
    x::T
    y::T
  end

  A = SharedArray{ShPoint{Float64}}(3)
  A .= [ShPoint(rand(), rand()) for in in 1:length(A)]

  @everywhere mutable struct MutableShPoint{T <: Real}
    x::T
    y::T
  end

  @test_throws ArgumentError B=SharedArray{MutableShPoint{Float64}}(3)
end
