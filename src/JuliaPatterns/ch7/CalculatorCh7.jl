module CalculatorCh7

const days_per_year = 365

include("MortgageCh7.jl")
using .MortgageCh7: payment 

# function fot the main module
include("funcs.jl")

end
