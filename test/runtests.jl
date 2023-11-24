using Test

tests = [
  "Julia2ndLang/ch3",
  "Julia2ndLang/ch4",
  "Julia2ndLang/ch5",
  "Julia2ndLang/ch6",
  "Julia2ndLang/ch7",
  "Julia2ndLang/ch16",
  "JuliaPatterns/ch2",
  "JuliaPatterns/ch3",
  "JuliaPatterns/ch4",
  "JuliaPatterns/ch5",
  "JuliaPatterns/ch6",
  "JuliaPatterns/ch7",
  "JuliaPatterns/ch8",
  "JuliaPatterns/ch9",
  "JuliaPatterns/ch10",
  "JuliaPatterns/ch11",
  "JuliaPatterns/ch12",
  "JuliaPerformance/ch1",
  "JuliaPerformance/ch2",
  "JuliaPerformance/ch3",
]
if !isempty(ARGS)
  tests = ARGS  # Set list to same as command line args
end

@testset "All Tests" begin
  for t in tests
    include("$(t)/tests.jl")
  end
end
