using Test
using HTTP
using JuliaStudy.JuliaPatterns.WebCrawler
import JuliaStudy.JuliaPatterns.ExceptionStackFrames as ES

@testset "Exception Handling Patterns" begin
  reset_crawler!()
  add_site!(Target(url = "http://www.this-site-does-not-exist-haha.com"))
  # @test_throws HTTP.Exception crawl_sites!()

  reset_crawler!()
  add_site!(Target(url = "http://www.google.com/this-page-does-not-exist"))
  # @test_throws HTTP.Exception crawl_sites!()

  reset_crawler!()
  add_site!(Target(url = "http://www.google.com/this-page-does-not-exist"))
  crawl_sites!()
end

@testset "Exception Stack Frames" begin
  @test_throws ErrorException ES.foo1()
  ES.foo1_1()
  ES.foo1_2()
end
