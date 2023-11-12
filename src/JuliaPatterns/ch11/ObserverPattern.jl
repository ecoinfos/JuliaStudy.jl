module ObserverPattern

mutable struct Account
  id::Int
  customer::String
  balance::Float64
end

const OBSERVERS = IdDict{Account, Vector{Function}}()

function register(a::Account, f::Function)
  fs = get!(OBSERVERS, a, Function[])
  println("Account $(a.id): registered observer function $(Symbol(f))")
  push!(fs, f)
end

function Base.setproperty!(a::Account, field::Symbol, value)
  previous_value = getfield(a, field)
  setfield!(a, field, value)
  fs = get!(OBSERVERS, a, Function[])
  foreach(f -> f(a, field, previous_value, value), fs)
end

function test_observer_func(a::Account,
  field::Symbol,
  previous_value,
  current_value)
  println("Account $(a.id): $field was changed from $previous_value to $current_value")
end

function test()
  a1 = Account(1, "John Doe", 100.00)
  register(a1, test_observer_func)
  a1.balance += 10.00
  a1.customer = "John Doe Jr."
  return nothing
end

end
