module NothingDataStructure

struct Nothing end
const nothing = Nothing()
struct Empty end

f(x::Union{Int, String}) = x^3

struct Wagon
  cargo::Int
  next::Union{Wagon, Nothing}
end

cargo(w::Wagon) = w.cargo + cargo(w.next)
cargo(w) = 0

struct Person
  firstname::Any
  lastname::Any
  Person() = new()
end

end
