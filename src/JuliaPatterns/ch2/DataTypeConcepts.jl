module DataTypeConcepts

using InteractiveUtils

export Asset, Property, Investment, Cash
export House, Apartment, FixedIncome, Equity
export Stock, muStock, StockHolding
export Holding, StockHolding2, StockHolding3, CashHolding
export Art, Painting
export subtypetree, subtypeTreeStr
export BasketOfStocks, BasketOfThings, newBasketOfThings

export describe

abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

struct Stock <: Equity
  symbol::String
  name::String
end

mutable struct muStock <: Equity
  symbol::String
  name::String
end

struct StockHolding{T <: Real}
  stock::Stock
  queantity::T
end

struct StockHolding2{T <: Real, P <: AbstractFloat}
  stock::Stock
  quantity::T
  price::P
  marketvalue::P
end

abstract type Holding{P} end

struct StockHolding3{T, P} <: Holding{P}
  stock::Stock
  quantity::T
  price::P
  marketvalue::P
end

struct CashHolding{P} <: Holding{P}
  currency::String
  amount::P
  marketvalue::P
end

abstract type Art end

struct Painting <: Art
  artist::String
  title::String
end

# Simple functions on abstract types
describe(a::Asset) = "Something valuable"
describe(e::Investment) = "Financial investment"
describe(e::Property) = "Physical property"

"""
location(p::Property)

Returns the location of the property as a tuple of (latitude, longitude).
"""
location(p::Property) = error("Location is not defined in the concrete type")

function walking_disance(p1::Property, p2::Property)
  loc1 = location(p1)
  loc2 = location(p2)
  return abs(loc1.x - loc2.x) + abs(loc1.y - loc2.y)
end

function describe(s::Stock)
  return s.symbol * "(" * s.name * ")"
end

struct BasketOfStocks
  stocks::Vector{Stock}
  reason::String
end

struct BasketOfThings
  things::Vector{Union{Painting, Stock}}
  reason::String
end

const Thing = Union{Painting, Stock}
struct newBasketOfThings
  things::Vector{Thing}
  reason::String
end

"""
    subtypetree(roottype, level = 1, indent = 4)

Display the entire type hierarchy starting from the specified `roottype`
"""
function subtypetree(roottype::Any, level::Int = 1, indent::Int = 4)
  level == 1 && println(roottype)
  for s in subtypes(roottype)
    println(join(fill(" ", level * indent)) * string(s))
    subtypetree(s, level + 1, indent)
  end
end

"""
    subtypeTreeStr(inType = nothing, indent::Int = 4) ::String

Return all sub types with tree stucture.

This function is improved version of `subtypetree` for easy testing.
"""
function subtypeTreeStr(inType = nothing, indent::Int = 4)::String
  outStr = ""

  if inType === nothing
    return outStr
  end

  level = 0
  genSubStr(inType, indent, level, outStr)
end

"""
    genSubStr(inType, indent::Int, level::Int, inStr::String) ::String

Generate substring for recursive call from subtypeTreeStr.
"""
function genSubStr(inType, indent::Int, level::Int, inStr::String)::String
  if level == 0
    outStr = string(inType)
  else
    outStr = inStr * "\n" * join(fill(" ", indent * level)) * string(inType)
  end

  for subtype in subtypes(inType)
    outStr = genSubStr(subtype, indent, level + 1, outStr)
  end
  outStr
end

end
