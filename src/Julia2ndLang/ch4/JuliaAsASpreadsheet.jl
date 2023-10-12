module JuiliaAsASpreadsheet

function transform(fun, xs)
  ys = []
  for x in xs
    push!(ys, fun(x))
  end
  ys
end

function sinus(x)
  n = 5
  taylor(i) = (-1)^(i - 1) * x^(2i - 1) / factorial(2i - 1)
  mapreduce(taylor, +, 1:n)
end

end
