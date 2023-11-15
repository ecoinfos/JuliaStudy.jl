module InheritanceAndVariance

abstract type Vehicle end
struct Car <: Vehicle end

move(v::Vehicle) = "$v has moved."

abstract type FlyingVehicle <: Vehicle end
liftoff(v::FlyingVehicle) = "$v has lifted off."

struct Helicopter <: FlyingVehicle end
liftoff(v::Helicopter) = "$v has lifted off vertically."

abstract type Animal end
struct Horse <: Animal end
move(h::Horse) = "$h running fast."

abstract type Veterbrate end
abstract type Mammal <: Veterbrate end
abstract type Reptile <: Veterbrate end

struct Cat <: Mammal
  name::Any
end

struct Dog <: Mammal
  name::Any
end

struct Crocodile <: Reptile
  name::Any
end

Base.show(io::IO, cat::Cat) = print(io, "Cat ", cat.name)
Base.show(io::IO, dog::Dog) = print(io, "dog ", dog.name)
Base.show(io::IO, croc::Crocodile) = print(io, "Crocodile ", croc.name)

function adopt(m::Mammal)
  println(m, " is now adopted.")
  return m
end

adopt(ms::Array{Mammal, 1}) = "adopted " * string(ms)

function adopt2(ms::Array{T, 1}) where {T <: Mammal}
  return "accepted same kind:" * string(ms)
end

friend(m::Mammal, f::Mammal) = "$m and $f become friends."

const SignFunctions = Union{typeof(isodd), typeof(iseven)}
myall(f::SignFunctions, a::AbstractArray) = all(f, a)

female_dogs = [Dog("Pinky"), Dog("Pinny"), Dog("Moonie")]
female_cats = [Cat("Minnie"), Cat("Queenie"), Cat("Kittie")]

select(::Type{Dog}) = rand(female_dogs)
select(::Type{Cat}) = rand(female_cats)
match(m::Mammal) = select(typeof(m))

# It's ok to kiss mammals :-)
kiss(m::Mammal) = "$m kissed!"

# Meet a partner
function meet_partner(finder::Function, self::Mammal)
  partner = finder(self)
  kiss(partner)
end

neighbor(m::Mammal) = Crocodile("Solomon")

buddy(cat::Cat) = rand([Dog("Astro"), Dog("Goofy"), Cat("Lucifer")])

struct PredicateFunction{T, S}
  f::Function
end

function (pred::PredicateFunction{T, S})(x::T; kwargs...) where {T, S}
  pred.f(x; kwargs...)
end

function safe_all(pred::PredicateFunction{T, S},
  a::AbstractArray) where {T <: Any, S <: Bool}
  all(pred, a)
end

triple(x::Array{T, 1}) where {T <: Real} = 3x
triple2(x::Array{T, 1} where {T <: Real}) = 3x

add(a::Array{T, 1}, x::T) where {T <: Real} = (T, a .+ x)

diagonal(x::T, y::T) where {T <: Number} = T

not_diagonal(A::Array{T, 1}, x::T, y::T) where {T <: Number} = T

mytypes1(a::Array{T, 1}, x::S) where {S <: Number, T <: S} = T
mytypes2(a::Array{T, 1}, x::S) where {S <: Number, T <: S} = S

end
