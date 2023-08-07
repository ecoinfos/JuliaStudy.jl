module MecrosAndMetaprogramming

using Dates
using Unrolled
using DataFrames

export timeit, hello
export @hello, @identify, @compose_twice, @ntimes
export @ndf_str, @doubled
export doubled, doubled2

function timeit(func::Function)
  t1 = now()
  result = func()
  t2 = now()
  elapsed = t2 - t1
  println("It took ", elapsed)
  result
end

@unroll function hello(xs)
  @unroll for i in xs
    println("hello: ", i)
  end
end

macro hello()
  return :(for i in 1:3
    println("Hello world")
  end)
end

macro hello(n)
  return :(for i in 1:($n)
    println("Hello world")
  end)
end

macro identify(ex)
  dump(ex)
  return ex
end

macro compose_twice(ex)
  @assert ex.head == :call
  @assert length(ex.args) == 2
  me = copy(ex)
  ex.args[2] = me
  return ex
end

macro ntimes(n, ex)
  quote
    times = $(esc(n))
    for i in 1:times
      $(esc(ex))
    end
  end
end

macro ndf_str(s)
  nstr, spec = split(s, ":")
  n = parse(Int, nstr)  # number of rows
  types = split(spec, ",")  # column type specifications
  num_columns = length(types)
  mappings = Dict("f64" => Float64, "f32" => Float32,
    "i64" => Int64, "i32" => Int32, "i16" => Int16, "i8" => Int8)
  column_types = [mappings[t] for t in types]
  column_names = [Symbol("x$i") for i in 1:num_columns]
  DataFrame([column_names[i] => rand(column_types[i], n) for i in 1:num_columns]...)
end

macro doubled(ex)
  return :(2 * $(esc(ex)))
end

@generated function doubled(x)
  return :(2 * x)
end

@generated function doubled2(x)
  @show x
  return :(2 * x)
end

end
