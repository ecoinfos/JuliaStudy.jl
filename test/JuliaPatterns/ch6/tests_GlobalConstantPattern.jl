using Test
using JuliaStudy.JuliaPatterns.GlobalConstantPattern
using BenchmarkTools
using InteractiveUtils

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
