module DataTypeConcepts

using InteractiveUtils

export Asset, Property, Investment, Cash
export House, Apartment, FixedIncome, Equity
export subtypetree, subtypeTreeStr

abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

"""
    subtypeTreeStr(inType = nothing, indent::Int = 4) ::String

Return all sub types with tree stucture.

This function is improved version of `subtypetree` for easy testing.
"""
function subtypeTreeStr(inType = nothing, indent::Int = 4) ::String
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
function genSubStr(inType, indent::Int, level::Int, inStr::String) ::String
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

end
