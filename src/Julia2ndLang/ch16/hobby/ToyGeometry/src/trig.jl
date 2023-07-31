export sine, cosine

"""
    sine(x)

Calculate the sine of an angle `x` given in radians.
"""
function sine(x::Number)
  n = 5
  total = 0
  for i in 0:n
    total += (-1)^i * x^(2i + 1) / factorial(2i + 1)
  end
  total
end

"""
    cosine(x::Number)

Calculate the cosine of an angle `x` given in radians
"""
function cosine(x::Number)
  n = 5
  mapreduce(+, 0:n) do i
    (-1)^i * x^(2i) / factorial(2i)
  end
end

"""
    factorial(n)

Get factorial of n.
"""
function factorial(n)
  if n > 2
    n * factorial(n - 1)
  elseif n > 0
    n
  elseif n == 0
    1
  else
    err = DomainError(n, "`n` must not be negative.")
    throw(err)
  end
end
