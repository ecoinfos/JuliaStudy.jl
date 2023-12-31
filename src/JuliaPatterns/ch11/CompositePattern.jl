module CompositePattern

struct Holding
  symbol::String
  qty::Int
  price::Float64
end

function Base.show(io::IO, h::Holding)
  print(io, h.symbol, " ", h.qty, " shares @ \$", h.price)
end

struct Portfolio
  symbol::String
  name::String
  stocks::Vector{Holding}
  subportfolios::Vector{Portfolio}
end

Base.show(io::IO, p::Portfolio) = myshow(io, p)

function myshow(io::IO, p::Portfolio, level = 0)
  println("  "^level, p.name, " (", p.symbol, ")")
  if length(p.stocks) > 0
    println(io, "  ", "  "^level, "Holdings:")
    foreach(h -> println(io, "  "^level, "    ", h), p.stocks)
  end
  if length(p.subportfolios) > 0
    foreach(subpf -> myshow(io, subpf, level + 1), p.subportfolios)
  end
end

function Portfolio(symbol::String, name::String, Holdings::Vector{Holding})
  Portfolio(symbol, name, Holdings, Portfolio[])
end

function Portfolio(symbol::String,
  name::String,
  subportfolios::Vector{Portfolio})
  Portfolio(symbol, name, Holding[], subportfolios)
end

function sample_portfolio()
  large_cap = Portfolio("TOMKA", "Large Cap Portfolio",
    [
      Holding("AAPL", 100, 275.15),
      Holding("IBM", 200, 134.21),
      Holding("GOOG", 300, 1348.83),
    ])
  small_cap = Portfolio("TOMKA", "Small Cap Portfolio",
    [
      Holding("ATO", 100, 107.05),
      Holding("BURL", 200, 225.09),
      Holding("ZBRA", 300, 257.80),
    ])
  p1 = Portfolio("TOMKF", "Fund of Funds Sleeve", [large_cap, small_cap])
  p2 = Portfolio("TOMKG", "Special Fund Sleeve", [Holding("C", 200, 76.39)])
  return Portfolio("TOMZ", "Master Fund", [p1, p2])
end

market_value(s::Holding) = s.qty * s.price

function market_value(p::Portfolio)
  mapreduce(market_value, +, p.stocks, init = 0.0) +
  mapreduce(market_value, +, p.subportfolios, init = 0.0)
end

end
