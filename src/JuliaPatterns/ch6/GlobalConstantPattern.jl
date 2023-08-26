module GlobalConstantPattern

export add_using_global_variable, add_using_function_args,
  add_using_global_constant, add_using_global_variable_typed,
  constant_folding_example, add_by_passing_global_variable,
  add_using_global_semi_constant

variable = 10
function add_using_global_variable(x)
  return x + variable
end

function add_using_function_args(x, y)
  return x + y
end

const constant = 10
function add_using_global_constant(x)
  return constant + x
end

function add_using_global_variable_typed(x)
  return x + variable::Int
end

function constant_folding_example()
  a = 2 * 3
  b = a + 1
  return b > 1 ? 10 : 20
end

function add_by_passing_global_variable(x, v)
  return x + v
end

# Initialize a constant Ref object with the value of 10
const semi_constant = Ref(10)

function add_using_global_semi_constant(x)
  return x + semi_constant[]
end

end
