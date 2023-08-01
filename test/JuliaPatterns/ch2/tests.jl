include("setup.jl")

@testset "Chapter 2: Calculator" begin
  @testset "interest" begin
    @test interest(1, 1) == 2
    @test Calculator.interest(1, 1) == 2
    @test JuliaPatterns.Calculator.interest(1, 1) == 2
    @test parentmodule(interest) == Calculator
  end
  @testset "rate" begin
    @test rate(1, 1) == 1
    @test rate(1, 2) == 2
    @test rate(2, 1) == 0.5
    @test rate(3, 1)≈0.33 rtol=1e-2
  end
end

@testset "Chapter 2: DataTypeConcepts" begin
  @testset "Type Hierarchy" begin
    @test subtypes(Asset) == Any[Cash, Investment, Property]
    @test subtypes(Asset) == Any[DataTypeConcepts.Cash,
      DataTypeConcepts.Investment,
      DataTypeConcepts.Property]
    @test supertype(Equity) == Investment
  end
end

function subtypeTreeStr(inType = nothing, indent::Int = 4)
  outStr = ""

  if inType === nothing
    return outStr
  end

  # outStr *= string(inType)
  #
  # for subypeStr in subtypes(inType)
  #   outStr *= "\n" * join(fill(" ", indent)) * string(subypeStr)
  # end
  level = 0
  genSubStr(inType, indent, level, outStr)
end

function genSubStr(inType, indent::Int, level::Int, inStr::String)
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

@testset "Chapter 2: Subtypetree" begin
  @test subtypeTreeStr() == ""
  @test subtypeTreeStr(House) == "House"
  @test subtypeTreeStr(Apartment) == "Apartment"
  @test subtypeTreeStr(Cash) == "Cash"

  indent = 2

  expected = "Property" *
             "\n" * join(fill(" ", indent)) * "Apartment" *
             "\n" * join(fill(" ", indent)) * "House"
  @test subtypeTreeStr(Property, indent) == expected

  expected = "Investment" *
             "\n" * join(fill(" ", indent)) * "Equity" *
             "\n" * join(fill(" ", indent)) * "FixedIncome"
  @test subtypeTreeStr(Investment, indent) == expected

  expected = "Asset" *
             "\n" * join(fill(" ", indent)) * "Cash" *
             "\n" * join(fill(" ", indent)) * "Investment" *
             "\n" * join(fill(" ", 2 * indent)) * "Equity" *
             "\n" * join(fill(" ", 2 * indent)) * "FixedIncome" *
             "\n" * join(fill(" ", indent)) * "Property" *
             "\n" * join(fill(" ", 2 * indent)) * "Apartment" *
             "\n" * join(fill(" ", 2 * indent)) * "House"
  @test subtypeTreeStr(Asset, indent) == expected
end
