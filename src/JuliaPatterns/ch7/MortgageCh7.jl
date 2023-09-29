module MortgageCh7

# Access to parent module's variable
using ..CalculatorCh7: days_per_year

function payment(amount, rate, year)
  monthly_rate = rate / 12
  factor = (1 + monthly_rate)^(12 * year)
  return amount * monthly_rate * factor / (factor - 1)
end

function get_days_per_year()
  return days_per_year
end

end
