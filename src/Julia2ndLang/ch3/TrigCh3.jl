module TrigCh3

export sine, cosine, tangent
export fac, fac2, fac4, fac5, fac6

function sine(x)
  n = 5
  total = 0
  for i in 0:n
    total += (-1)^i * x^(2i + 1) / factorial(2i + 1)
  end
  total
end

function cosine(x)
  n = 5
  total = 0
  for i in 0:n
    total += (-1)^i * x^(2i) / factorial(2i)
  end
  total
end

function tangent(x)
  sine(x) / cosine(x)
end

fac(n) = prod(1:n)

function fac2(n)
  prod = 1
  while n >= 1
    prod *= n
    n -= 1
  end
  prod
end

function fac4(n)
  if n <= 2
    return n
  end
  n * fac4(n - 1)
end

function fac5(n)
  if n <= 2
    n
  else
    n * fac5(n - 1)
  end
end

function fac6(n)
  if n >= 2
    n * fac6(n - 1)
  elseif n > 0
    n
  elseif n == 0
    1
  else
    err = DomainError(n, "`n` must not be negative.")
    throw(err)
  end
end

end
