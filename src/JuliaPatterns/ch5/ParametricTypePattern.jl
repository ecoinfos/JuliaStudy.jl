module ParametricTypePattern

using Dates

export StockOption, SingleTrade
export Call, Put, Long, Short
export payment, PairTrade

# Abstract type hirearchy for personal assets
abstract type Asset end
abstract type Investment <: Asset end
abstract type Equity <: Investment end

# Equity Instruments Types
struct Stock <: Equity
  symbol::String
  name::String
end

# Trading Types
abstract type Trade end

# Types (direction) of the trade
@enum LongShort Long Short

struct StockTrade <: Trade
  type::LongShort
  stock::Stock
  quantity::Int
  price::Float64
end

# Types of stock options
@enum CallPut Call Put

struct StockOption <: Equity
  symbol::String
  type::CallPut
  strike::Float64
  expiration::Date
end

struct StockOptionTrade <: Trade
  type::LongShort
  option::StockOption
  quantity::Int
  price::Float64
end

# Regardless of the investment being trade, the direction of
# trade (long/buy or short/sell) determines the sign of the
# payment amount.
sign(t::StockTrade) = t.type == Long ? 1 : -1
sign(t::StockOptionTrade) = t.type == Long ? 1 : -1

# market value of a trade is simply quantity times price
payment(t::StockTrade) = sign(t) * t.quantity * t.price
payment(t::StockOptionTrade) = sign(t) * t.quantity * t.price

struct SingleTrade{T <: Investment} <: Trade
  type::LongShort
  instrument::T
  quantity::Int
  price::Float64
end

# Return + or - sign for the direction of trade
function sign(t::SingleTrade{T}) where {T}
  return t.type == Long ? 1 : -1
end

# Calculate payment amount for the trade
function payment(t::SingleTrade{T}) where {T}
  return sign(t) * t.quantity * t.price
end

# Calculate payment amount for option trades (100 shares per contract)
function payment(t::SingleTrade{StockOption})
  return sign(t) * t.quantity * 100 * t.price
end

struct PairTrade{T <: Investment, S <: Investment} <: Trade
  leg1::SingleTrade{T}
  leg2::SingleTrade{S}
end

payment(t::PairTrade) = payment(t.leg1) + payment(t.leg2)

end
