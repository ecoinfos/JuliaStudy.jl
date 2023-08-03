export Warrior, Archer, Pikeman, Knight
export shoot!, resupply!, mount!, dismount!, ==
export attack!, battle!

abstract type Warrior end

mutable struct Archer <: Warrior
  name::String
  health::Int
  arrows::Int
end

mutable struct Pikeman <: Warrior
  name::String
  health::Int
end

mutable struct Knight <: Warrior
  name::String
  health::Int
  mounted::Bool
end

"""
    Base.:(==)(a::Archer, b::Archer)

See https://stackoverflow.com/questions/70362843/how-to-create-equality-test-case-for-custom-structures-in-julia
"""
function Base.:(==)(a::Archer, b::Archer)
  a.name === b.name && a.health === b.health && a.arrows === b.arrows
end

function shoot!(archer::Archer)
  if archer.arrows > 0
    archer.arrows -= 1
  end
  archer
end

function resupply!(archer::Archer)
  archer.arrows = 24
  archer
end

function mount!(knight::Knight)
  knight.mounted = true
end

function dismount!(knight::Knight)
  knight.mounted = false
end

function attack!(a::Archer, b::Archer)
  if a.arrows > 0
    shoot!(a)
    damage = 6 + rand(1:6)
    b.health = max(b.health - damage, 0)
  end
  a.health, b.health
end

function attack!(a::Archer, b::Knight)
  if a.arrows > 0
    shoot!(a)

    damage = rand(1:6)
    if b.mounted
      damage += 3
    end
    b.health = max(b.health - damage, 0)
  end
  a.health, b.health
end

function attack!(a::Knight, b::Knight)
  a.health = max(a.health - rand(1:6), 0)
  b.health = max(b.health - rand(1:6), 0)
  a.health, b.health
end

function attack!(a::Archer, b::Pikeman)
  if a.arrows > 0
    shoot!(a)
    damage = 4 + rand(1:6)
    b.health = max(b.health - damage, 0)
  end
  a.health, b.health
end

function battle!(a::Warrior, b::Warrior)
  attack!(a, b)

  result = ""
  if a.health == 0 && b.health == 0
    result = a.name * " and " * b.name * " destroyed each other"
  elseif a.health == 0
    result = b.name * " defeated " * a.name
  elseif b.health == 0
    result = a.name * " defeated " * b.name
  else
    result = b.name * " survived attack from " * a.name
  end
  result
end
