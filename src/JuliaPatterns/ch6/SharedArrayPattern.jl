module SharedArrayPattern

using Distributed, SharedArrays
using Statistics: std, mean, median
using StatsBase: skewness, kurtosis

export make_data_directories, locate_file, generate_test_data
export load_data!, read_val_file!, locate_file2
export std_by_security, stats_by_security, std_by_security2, stats_by_security2

function make_data_directories(folder)
  mkdir(folder)
  for i in 0:99
    mkdir(folder * "/$i")
  end
end

function locate_file(index)
  id = index - 1
  dir = string(id % 100)
  joinpath(dir, "sec$(id).dat")
end

function generate_test_data(nfiles)
  for i in 1:nfiles
    A = rand(10000, 3)
    file = locate_file(i)
    open(file, "w") do io
      write(io, A)
    end
  end
end

@everywhere function locate_file2(index)
  id = index - 1
  dir = string(id % 100)
  joinpath(dir, "sec$(id).dat")
end

@everywhere function read_val_file!(index, dest)
  filename = locate_file2(index)
  (nstates, nattrs) = size(dest)[1:2]
  open(filename) do io
    nbytes = nstates * nattrs * 8
    buffer = read(io, nbytes)
    A = reinterpret(Float64, buffer)
    dest[:, :, index] = A
  end
end

function load_data!(nfiles, dest)
  @sync @distributed for i in 1:nfiles
    read_val_file!(i, dest)
  end
end

"""
    std_by_security(valuation)

Find standard deviation of each attribute for each security
"""
function std_by_security(valuation)
  (_, nattr, n) = size(valuation)
  result = zeros(n, nattr)
  for i in 1:n
    for j in 1:nattr
      result[i, j] = std(valuation[:, j, i])
    end
  end
  return result
end

function std_by_security2(valuation)
  (_, nattr, n) = size(valuation)
  result = SharedArray{Float64}(n, nattr)
  @sync @distributed for i in 1:n
    for j in 1:nattr
      result[i, j] = std(valuation[:, j, i])
    end
  end
  return result
end

function stats_by_security(valuation, funcs)
  (_, nattr, n) = size(valuation)
  result = zeros(n, nattr, length(funcs))
  for i in 1:n
    for j in 1:nattr
      for (k, f) in enumerate(funcs)
        result[i, j, k] = f(valuation[:, j, i])
      end
    end
  end
  return result
end

function stats_by_security2(valuation, funcs)
  (_, nattr, n) = size(valuation)
  result = SharedArray{Float64}((n, nattr, length(funcs)))
  @sync @distributed for i in 1:n
    for j in 1:nattr
      for (k, f) in enumerate(funcs)
        result[i, j, k] = f(valuation[:, j, i])
      end
    end
  end
  return result
end

end
