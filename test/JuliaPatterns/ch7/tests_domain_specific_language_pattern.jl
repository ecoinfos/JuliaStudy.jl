using Test
using JuliaStudy.JuliaPatterns.DomainSpecificLanguagePattern
using MacroTools

@testset "Domain Specific Language Pattern" begin
  algae_model = LModel("A")
  add_rule!(algae_model, "A", "AB")
  add_rule!(algae_model, "B", "A")
  algae_model

  state = LState(algae_model)
  @test state.result == ["A"]
  state = next(state)
  @test state.result == ["A", "B"]
  state = next(state)
  @test state.result == ["A", "B", "A"]
  state = next(state)
  @test state.result == ["A", "B", "A", "A", "B"]
  state = next(state)
  @test state.result == ["A", "B", "A", "A", "B", "A", "B", "A"]

  @capture(:(x = 1), x=val_)
  @test val == 1

  ex = :(axium:A)
  match_axium = @capture(ex, axium:sym_)
  @test sym == :A

  ex2 = :(rule:(A -> AB))
  @test @capture(ex2, rule:(original_ -> replacement_)) == true
  # @test String(original) == "A"
  # @test String((replacement |> rmlines).args[1]) == "AB"

  ex3 = quote
    x = 1
    y = x^2 + 3
  end |> rmlines

  MacroTools.postwalk(x -> @show(x), ex3)
  MacroTools.prewalk(x -> @show(x), ex3)

  ex4 = quote
    axiom:A
    rule:(A -> AB)
    rule:(B -> A)
  end

  MacroTools.postwalk(walk, ex4) |> rmlines

  @macroexpand(@lsys begin
    axium:A
    rule:(A -> AB)
    rule:(B -> A)
  end) |> rmlines

  algae_model2 = @lsys begin
    axiom:A
    rule:(A -> AB)
    rule:(B -> A)
  end
  @test algae_model2.axiom == ["A"]
  algae_model2.rules

  state2 = LState(algae_model2)
  @test state2.result == ["A"]

  state2 = next(state2)
  @test state2.result == ["A", "B"]
  state2 = next(state2)
  @test state2.result == ["A", "B", "A"]
  state2 = next(state2)
  @test state2.result == ["A", "B", "A", "A", "B"]
  state2 = next(state2)
  @test state2.result == ["A", "B", "A", "A", "B", "A", "B", "A"]
end
