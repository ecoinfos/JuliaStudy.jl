module DomainSpecificLanguagePattern
using MacroTools

export LModel, add_rule!
export LState, next, walk, @lsys

# using DifferentialEquations
#
# @ode_def begin
#   dx = σ * (y - x)
#   dy = x * (ρ - z) - y
#   dz = x * y - β * z
# end σ ρ β

struct LModel
  axiom::Any
  rules::Any
end

"Create a L-system model."
LModel(axiom) = LModel([axiom], Dict())

"Add rule to a model."
function add_rule!(model::LModel,
  left::T,
  right::T) where {T <: AbstractString}
  model.rules[left] = split(right, "")
  return nothing
end

"Display model nicely."
function Base.show(io::IO, model::LModel)
  println(io, "LModel:")
  println(io, " Axiom: ", join(model.axiom))
  for k in sort(collect(keys(model.rules)))
    println(io, " Rule: ", k, " -> ", join(model.rules[k]))
  end
end

struct LState
  model::Any
  current_iteration::Any
  result::Any
end

"Create a L-system state from a `model`."
LState(model::LModel) = LState(model, 1, model.axiom)

function next(state::LState)
  new_result = []
  for el in state.result
    # Look up `el` from the rules dictionary and append to `new_result`.
    # Just default to the element itself when it is not  found
    next_elements = get(state.model.rules, el, el)
    append!(new_result, next_elements)
  end
  return LState(state.model, state.current_iteration + 1, new_result)
end

"Compact the result suitable for display"
result(state::LState) = join(state.result)
function Base.show(io::IO, s::LState)
  print(io, "LState(", s.current_iteration, "): ", result(s))
end

macro lsys(ex)
  ex = MacroTools.postwalk(walk, ex)
  push!(ex.args, :( model ))
  return ex
end


function walk(ex)
  match_axiom = @capture(ex, axiom:sym_)
  if match_axiom
    sym_str = String(sym)
    return :(model = LModel($sym_str))
  end
  match_rule = @capture(ex, rule:original_ -> replacement_)
  if match_rule
    original_str = String(original)
    # MethodError: no method matching String(::Expr)
    # Ref: https://github.com/timholy/SnoopCompile.jl/issues/266
    # replacement_str = String(replacement)
    # Ref: https://docs.julialang.org/en/v1/manual/metaprogramming/
    replacement_str = String((replacement |> rmlines).args[1])
    return :(add_rule!(model, $original_str, $replacement_str))
  end
  return ex
end

end
