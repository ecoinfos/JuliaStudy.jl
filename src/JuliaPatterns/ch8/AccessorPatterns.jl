module AccessorPatterns

using Distributions

mutable struct Simulation{N}
  heatmap::Array{Float64, N}
  stats::NamedTuple{(:mean, :std)}
end

function simulate(distribution, dims, n)
  tp = ntuple(i -> n, dims)
  heatmap = rand(distribution, tp...)
  return Simulation{dims}(heatmap, (mean = mean(heatmap), std = std(heatmap)))
end

end
