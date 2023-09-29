module HolyTraitsPattern

using SimpleTraits

# To fix breaking tests in ch2, need to define separate types.
# using JuliaStudy.JuliaPatterns.DataTypeConcepts: House,
#   Equity, FixedIncome, Cash, Investment

abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

struct Residence <: House
  location::Any
end

struct Stock <: Equity
  symbol::Any
  name::Any
end

struct TreasuryBill <: FixedIncome
  cusip::Any
end

struct Money <: Cash
  currency::Any
  amount::Any
end

abstract type LiquidityStyle end
struct IsLiquid <: LiquidityStyle end
struct IsIlliquid <: LiquidityStyle end

# Default behavior is illiquid 
LiquidityStyle(::Type) = IsIlliquid()

# Cash is always liquid.
LiquidityStyle(::Type{<:Cash}) = IsLiquid()

# Any subtype of Investment is liquid.
LiquidityStyle(::Type{<:Investment}) = IsLiquid()

tradable(x::T) where {T} = tradable(LiquidityStyle(T), x)
tradable(::IsLiquid, x) = true
tradable(::IsIlliquid, x) = false

# The thing has a market price if it is liquid
marketprice(x::T) where {T} = marketprice(LiquidityStyle(T), x)
function marketprice(::IsLiquid, x)
  error("Please implement pricing function for ", typeof(x))
end
function marketprice(::IsIlliquid, x)
  error("Price for illiquid asset $x is not available.", typeof(x))
end

# Simple pricing functions for Money and Stock
marketprice(x::Money) = x.amount
marketprice(::Stock) = rand(200:250)

abstract type Literature end

struct Book <: Literature
  name::Any
end

# Assign trait
LiquidityStyle(::Type{Book}) = IsLiquid()
# Sample price function
marketprice(b::Book) = 10.0

@traitdef IsLiquid2{T}
@traitimpl IsLiquid2{Cash}
@traitimpl IsLiquid2{Investment}

@traitfn function marketprice2(x::::IsLiquid2)
  error("Please implement pricing function for ", typeof(x))
end

@traitfn function marketprice2(x::::(!IsLiquid2))
  error("Price for illiquid asset $x is not available.")
end

marketprice2(x::Stock) = 123

end
