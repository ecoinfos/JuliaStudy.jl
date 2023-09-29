function interest(amount, rate)
  return amount * (1 + rate)
end

function rate(amount, interest)
  return interest / amount
end

# use payment function from Mortgage.jl
function mortgage(home_price, down_payment, rate, years)
  return payment(home_price - down_payment, rate, years)
end
