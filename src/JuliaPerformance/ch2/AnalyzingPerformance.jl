module AnalyzingPerformance

using Statistics
using TimerOutputs

function randmsq()
  x = rand(10000, 1000)
  y = mean(x .^ 2, dims = 1)
  return y
end

const to = TimerOutput()

function randmsq_timed()
  @timeit to "randmsq" begin
    x = @timeit to "rand" rand(10000, 1000)
    y = @timeit to "mean" mean(x .^ 2, dims = 1)
    return y
  end
end

end
