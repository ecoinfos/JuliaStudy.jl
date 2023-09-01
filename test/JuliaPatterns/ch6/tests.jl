include("tests_GlobalConstantPattern.jl") 
include("tests_StructOfArraysPattern.jl") 
# remove test to prevent out of space error in Github Actions.
# include("tests_SharedArraysPattern.jl") 
include("tests_MemoizationPattern.jl") 
include("tests_BarrierFunctionPattern.jl")
