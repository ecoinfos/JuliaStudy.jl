module StrategyPattern

using Memoize

abstract type Algo end

struct Memoized <: Algo end
struct Iterative <: Algo end

@memoize function _fib(n)
  n <= 2 ? 1 : _fib(n - 1) + _fib(n - 2)
end

function fib(::Memoized, n)
  println("Using memoization algorithm")
  _fib(n)
end

function fib(::Iterative, n)
  println("Using iterative algorithm")
  n <= 2 && return 1
  prev1, prev2 = 1, 1
  local curr
  for _ in 3:n
    curr = prev1 + prev2
    prev1, prev2 = curr, prev1
  end
  return curr
end

function fib(n)
  algo = n > 50 ? Memoized() : Iterative()
  return fib(algo, n)
end


end
