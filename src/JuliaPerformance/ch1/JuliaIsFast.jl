module JuliaIsFast

function mandel(c)
  z = c
  maxiter = 80
  for n in 1:maxiter
    if abs(z) > 2
      return n - 1
    end
    z = z^2 + c
  end
  return maxiter
end

end
