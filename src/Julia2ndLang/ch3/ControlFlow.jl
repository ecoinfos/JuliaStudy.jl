module ControlFlow

export deg2rad, print_sin_table, f
export fib, fib2, fibi

deg2rad(θ) = (θ / 360) * 2π

function print_sin_table(increment, max_angle)
  angle = 0
  while angle <= max_angle
    rad = deg2rad(angle)
    x = sin(rad)
    println(x)
    angle = angle + increment
  end
end

function f(n)
  total = 0
  for x in 1:n
    total += 2x + 1
  end
  total
end

function fib(n)
  if n == 0
    0
  elseif n == 1
    1
  else
    fib(n - 1) + fib(n - 2)
  end
end

function fib2(n)
  if 0 <= n <= 1
    n
  else
    fib2(n - 1) + fib2(n - 2)
  end
end

function fibi(n)
  if 0 <= n <= 1
    return n
  end

  prev = 0
  x = 1
  for _ in 2:n
    tmp = x
    x += prev
    prev = tmp
  end
  x
end

end
