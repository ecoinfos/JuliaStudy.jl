module TemplateMethodPattern

using DataFrames, RDatasets, GLM, LinearAlgebra

split_data(df::DataFrame, keep::Float64) =
  let b = rand(size(df, 1)) .< keep
    (df[b, :], df[.!b, :])
  end

function fit(df::DataFrame, response::Symbol, predictors::Vector{Symbol})
  formula = Term(response) ~ +(Term.(predictors)...)
  return lm(formula, df)
end

rmse(ys) = norm(ys) / sqrt(length(ys))

function validate(df, model, response)
  yhat = predict(model, df)
  y = df[:, response]
  return (result=[y yhat], rmse=rmse(yhat .- y))
end

function run(data::DataFrame, response::Symbol, predictors::Vector{Symbol})
  train, test = split_data(data, 0.7)
  model = fit(train, response, predictors)
  validate(test, model, response)
end

function run2(data::DataFrame,
  response::Symbol,
  predictors::Vector{Symbol};
  fit = fit,
  split_data = split_data,
  validate = validate)
  train, test = split_data(data, 0.7)
  model = fit(train, response, predictors)
  validate(test, model, response)
end

function fit_glm(df::DataFrame, response::Symbol, predictors::Vector{Symbol})
  formula = Term(response) ~ +(Term.(predictors)...)
  return glm(formula, df, Normal(), IdentityLink())
end

end
