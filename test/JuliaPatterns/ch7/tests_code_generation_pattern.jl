using Test
using JuliaStudy.JuliaPatterns.CodeGenerationPattern
using Revise, CodeTracking
using MacroTools

@testset "Code Generation Pattern" begin
  info_logger_ori = Logger("/tmp/info_ori.log", INFO)
  info_ori!(info_logger_ori, "hello", 123)
  readlines("/tmp/info_ori.log")

  error_logger_ori = Logger("/tmp/error_ori.log", ERROR)
  info_ori!(error_logger_ori, "hello", 123)
  readlines("/tmp/error_ori.log")

  info_logger = Logger("/tmp/info.log", INFO)
  info!(info_logger, "hello", 123)
  warning!(info_logger, "hello", 456)
  error!(info_logger, "hello", 789)
  readlines("/tmp/info.log")

  error_logger = Logger("/tmp/error.log", ERROR)
  info!(error_logger, "hello", 123)
  warning!(error_logger, "hello", 456)
  error!(error_logger, "hello", 789)
  readlines("/tmp/error.log")

  methods(error!)
  methods(error!) |> first
  methods(error!) |> first |> definition

  MacroTools.postwalk(rmlines, definition(first(methods(error!))))
end

@testset "Non Code Generation Technique" begin
  info_logger2 = Logger("/tmp/info2.log", INFO)
  info2!(info_logger2, "hello", 123)
  warning2!(info_logger2, "hello", 456)
  error2!(info_logger2, "hello", 789)
  readlines("/tmp/info2.log")

  error_logger2 = Logger("/tmp/error2.log", ERROR)
  info2!(error_logger2, "hello", 123)
  warning2!(error_logger2, "hello", 456)
  error2!(error_logger2, "hello", 789)
  readlines("/tmp/error2.log")


  info_logger3 = Logger("/tmp/info3.log", INFO)
  info3!(info_logger3, "hello", 123)
  warning3!(info_logger3, "hello", 456)
  error3!(info_logger3, "hello", 789)
  readlines("/tmp/info3.log")

  error_logger3 = Logger("/tmp/error3.log", ERROR)
  info3!(error_logger3, "hello", 123)
  warning3!(error_logger3, "hello", 456)
  error3!(error_logger3, "hello", 789)
  readlines("/tmp/error3.log")
end
