using Test
import JuliaStudy.JuliaPatterns.TemplateMethodPattern as TMP

using RDatasets
using GLM
using LinearAlgebra

boston = dataset("MASS", "Boston")

@testset "RDatasets" begin
  RDatasets.datasets("MASS")
  RDatasets.datasets("MASS")[3, "Title"]
  boston[1, :]
  @test names(boston) |> length == 14
end

@testset "Split data" begin
  @test size(boston, 1) == 506
  @test size(boston, 2) == 14

  b = rand(size(boston, 1)) .< 0.7
  .!b
  (boston[b, :], boston[.!b, :])
end

@testset "Fit" begin
  formula = Term(:MedV) ~ +(Term.([:Rm, :Tax, :Crim])...)
  lm(formula, boston)
end

@testset "RMSE" begin
  ys = [1.0, 1.0, 1.0, 1.0]
  @test norm(ys) == 2.0
  @test sqrt(length(ys)) == 2.0
  @test TMP.rmse(ys) == 1.0
end

@testset "Validate" begin
  train, test = TMP.split_data(boston, 0.7)
  response = :MedV
  predictors = [:Rm, :Tax, :Crim]
  model = TMP.fit(train, response, predictors)
  yhat = predict(model, test)
  y = test[:, response]
  (result = [y yhat], rmse = TMP.rmse(yhat .- y))
end

@testset "Template Method Pattern" begin
  result, rmse = TMP.run(boston, :MedV, [:Rm, :Tax, :Crim])
  println(rmse)

  result2, rmse2 = TMP.run2(boston,
    :MedV,
    [:Rm, :Tax, :Crim],
    fit = TMP.fit_glm)
  println(rmse2)
end
