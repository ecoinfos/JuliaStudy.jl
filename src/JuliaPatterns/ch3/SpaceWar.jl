module SpaceWar

export Position, Size
export Widget, move_up!, move_down!, move_left!, move_right!
export make_asteroids, make_asteroids2, make_asteroids3
export shoot, triangular_formation!
export random_move, random_leap!
export fire, process_file
export Spaceship, Asteroid, Missile, Laser
export collide, check_randomly
export explode, tow, group_anything, group_same_things

mutable struct Position
  x::Int
  y::Int
end

struct Size
  width::Int
  height::Int
end

struct Widget
  name::String
  position::Position
  size::Size
end

# Single-line functions
move_up!(widget::Widget, v::Int) = widget.position.y -= v
move_down!(widget::Widget, v::Int) = widget.position.y += v
move_left!(widget::Widget, v::Int) = widget.position.x -= v
move_right!(widget::Widget, v::Int) = widget.position.x += v

# define pretty print functions
Base.show(io::IO, p::Position) = print(io, "(", p.x, ", ", p.y, ")")
Base.show(io::IO, s::Size) = print(io, s.width, " x ", s.height)
function Base.show(io::IO, w::Widget)
  print(io, w.name, " at ", w.position, " size ", w.size)
end

function make_asteroids(N::Int, pos_range = 0:200, size_range = 10:30)
  pos_rand() = rand(pos_range)
  sz_rand() = rand(size_range)
  return [Widget("Asteroid #$i",
    Position(pos_rand(), pos_rand()),
    Size(sz_rand(), sz_rand())) for i in 1:N]
end

function make_asteroids2(N::Int; pos_range = 0:200, size_range = 10:30)
  pos_rand() = rand(pos_range)
  sz_rand() = rand(size_range)
  return [Widget("Asteroid #$i",
    Position(pos_rand(), pos_rand()),
    Size(sz_rand(), sz_rand())) for i in 1:N]
end

function make_asteroids3(; N::Int, pos_range = 0:200, size_range = 10:30)
  pos_rand() = rand(pos_range)
  sz_rand() = rand(size_range)
  return [Widget("Asteroid #$i",
    Position(pos_rand(), pos_rand()),
    Size(sz_rand(), sz_rand())) for i in 1:N]
end

function shoot(from::Widget, targets::Widget...)
  println("Type of targets: ", typeof(targets))
  for target in targets
    println(from.name, " --> ", target.name)
  end
end

function triangular_formation!(s1::Widget, s2::Widget, s3::Widget)
  x_offset = 30
  y_offset = 50
  s2.position.x = s1.position.x - x_offset
  s3.position.x = s1.position.x + x_offset
  s2.position.y = s3.position.y = s1.position.y - y_offset
  (s1, s2, s3)
end

function random_move()
  return rand([move_up!, move_down!, move_left!, move_right!])
end

function random_leap!(w::Widget, move_func::Function, distance::Int)
  move_func(w, distance)
  return w
end

function explode(x)
  println(x, " explorded!")
end

function clean_up_galaxy(asteroids)
  foreach(explode, asteroids)
end

function clean_up_galaxy2(asteroids)
  foreach(x -> println(x, " explorded!"), asteroids)
end

function clean_up_galaxy(asteroids, spaceships)
  ep = x -> println(x, " explorded!")
  foreach(ep, asteroids)
  foreach(ep, spaceships)
end

# Random healthyness function for tsting
healthy(::Widget) = rand(Bool)

function fire(f::Function, spaceship::Widget)
  if healthy(spaceship)
    f(spaceship)
  else
    println("Operation aborted as spaceship is not healthy")
  end
  return nothing
end

function process_file(func::Function, filename::AbstractString)
  ios = nothing
  try
    ios = open(filename)
    func(ios)
  finally
    close(ios)
  end
end

# A thing is anything that exist in the universe.
# Concreate type of Thing should always have the following fields.
#    1. position
#    2. size
abstract type Thing end

# Funtions that are applied for all Thing's
position(t::Thing) = t.position
size(t::Thing) = t.size
shape(::Thing) = :unknown

# Type of weapons
@enum Weapon Laser Missile

struct Spaceship <: Thing
  position::Position
  size::Size
  weapon::Weapon
end

shape(::Spaceship) = :saucer

struct Asteroid <: Thing
  position::Position
  size::Size
end

struct Rectangle
  top::Int
  left::Int
  bottom::Int
  right::Int
  function Rectangle(p::Position, s::Size)
    new(p.y + s.height, p.x, p.y, p.x + s.width)
  end
end

"""
    overlap(A::Rectangle, B::Rectangle)

check if two rectangles (A & B) overlap
"""
function overlap(A::Rectangle, B::Rectangle)
  return A.left < B.right && A.right > B.left && A.top > B.bottom &&
         A.bottom < B.top
end

function collide(A::Thing, B::Thing)
  println("Check collision of thing vs. thing")
  rectA = Rectangle(position(A), size(A))
  rectB = Rectangle(position(B), size(B))
  return overlap(rectA, rectB)
end

function collide(::Spaceship, ::Spaceship)
  println("Checking collision of spaceship vs. spaceship")
  return true   # just a test
end

function collide(::Asteroid, ::Thing)
  println("Checking collision of asteroid vs. thing")
  return true
end

function collide(::Thing, ::Asteroid)
  println("Checking collision of thing vs. asteroid")
  return false
end

function collide(::Asteroid, ::Asteroid)
  println("Checking collision of asteroid vs. asteroid")
  return true   # just a test
end

function check_randomly(things)
  for _ in 1:5
    two = rand(things, 2)
    collide(two...)
  end
end

"""
    explode(things::AbstractVector{Any})

explode an array of objects
"""
function explode(things::AbstractVector{T}) where {T <: Thing}
  for t in things
    println("Exploding ", t)
  end
end

"""
    tow(A::Spaceship, B::Thing)

specifying abstract/concrete types in method signature
"""
# function tow(A::Spaceship, B::Thing)
#   "tow 1"
# end

"""
    tow(A::Spaceship, B::T) where {T <: Thing}

equivalent of parametric type
"""
function tow(A::Spaceship, B::T) where {T <: Thing}
  "tow 1"
end

function group_anything(A::Thing, B::Thing)
  println("Grouped ", A, " and ", B)
end

function group_same_things(A::T, B::T) where {T <: Thing}
  println("Grouped ", A, " and ", B)
end

eltype(::AbstractVector{T}) where {T <: Thing} = T

end
