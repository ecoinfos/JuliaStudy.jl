abstract type Tank end

mutable struct SmallTank <: Tank
  propellant::Float64
end

mutable struct MediumTank <: Tank
  propellant::Float64
end

mutable struct LargeTank <: Tank
  propellant::Float64
end

# Accessor functions (getters)
drymass(::SmallTank) = 40.0
drymass(::MediumTank) = 250.0
drymass(::LargeTank) = 950.0

totalmass(::SmallTank) = 410.0
totalmass(::MediumTank) = 2_300.0
totalmass(::LargeTank) = 10_200.0

mutable struct FlexiTank <: Tank
  drymass::Float64
  totalmass::Float64
  propellant::Float64
end

# Accessors (getters) 
drymass(tank::FlexiTank) = tank.drymass
totalmass(tank::FlexiTank) = tank.totalmass

# Accessors (setters and getters)
propellant(tank::Tank) = tank.propellant

function propellant!(tank::Tank, amount::Real)
  if 0 <= amount + drymass(tank) <= totalmass(tank)
    tank.propellant = amount
  else
    msg = "Propellant mass plus dry mass must be less than total mass"
    throw(DomainError(amount, msg))
  end
end

isempty(tank::Tank) = tank.propellant <= 0
mass(tank::Tank) = drymass(tank) + propellant(tank)

# Actions
function refill!(tank::Tank)
  propellant!(tank, totalmass(tank) - drymass(tank))
  tank
end

function consume!(tank::Tank, amount::Real)
  remaining = max(propellant(tank) - amount, 0)
  propellant!(tank, remaining)
  remaining
end

function SmallTank()
  refill!(SmallTank(0))
end

function MediumTank()
  refill!(MediumTank(0))
end

function LargeTank()
  refill!(LargeTank(0))
end

function FlexiTank(drymass::Number, totalmass::Number)
  FlexiTank(drymass, totalmass, totalmass - drymass)
end

mutable struct FlexiTank2 <: Tank
  drymass::Float64
  totalmass::Float64
  propellant::Float64

  function FlexiTank2(drymass::Number, totalmass::Number)
    new(drymass, totalmass, totalmass - drymass)
  end
end
