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

heatmap(s::Simulation) = s.heatmap
stats(s::Simulation) = s.stats

function heatmap!(s::Simulation{N},
  new_heatmap::AbstractArray{Float64, N}) where {N}
  if length(unique(size(new_heatmap))) != 1
    error("All dimensions must have same size.")
  end

  s.heatmap = new_heatmap
  s.stats = (mean = mean(new_heatmap), std = std(new_heatmap))
  return nothing
end

mutable struct Simulation2{N}
  _heatmap::Array{Float64, N}
  _stats::NamedTuple{(:mean, :std)}
end

end
