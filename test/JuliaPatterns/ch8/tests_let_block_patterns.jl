using Test
using JuliaStudy.JuliaPatterns.WebCrawler

@testset "Web Crawler" begin
  add_site!(Target(url = "https://www.cnn.com"))
  add_site!(Target(url = "https://www.yahoo.com"))
  @test length(current_sites()) == 2

  @test_throws UndefVarError WebCrawler.index_site!()
  @test_throws UndefVarError WebCrawler.sites
end
