using Test
using JuliaStudy.JuliaPatterns.KeywordDefinitionPattern

@testset "Keyword definition pattern" begin
  style = TextStyle("Arial", 11, "bold", "black", "white", "left", 0)
  @test style.font_family == "Arial"

  style2 = TextStyle(alignment = "left",
    font_family = "Arial",
    font_weight = "bold",
    font_size = 11)
  @test style2.font_family == "Arial"
  @test style2.foreground_color == "black"

  methods(TextStyle2)
  style3 = TextStyle2(alignment = "left",
    font_family = "Arial",
    font_weight = "bold",
    font_size = 11)
  @test style3.font_family == "Arial"
  @test style3.foreground_color == "black"
  @test_throws UndefKeywordError TextStyle2()
  @test_throws UndefKeywordError TextStyle2(font_family = "Arial")
end
