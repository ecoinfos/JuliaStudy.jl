using Test
import JuliaStudy.JuliaPatterns.HackerNewsAnalysis as HN
using HTTP
using JSON3
using BenchmarkTools

@testset "Hacker News Analysis" begin
  HN.fetch_top_stories()

  url = "https://hacker-news.firebaseio.com/v0/topstories.json"
  response = HTTP.request("GET", url)
  @test typeof(response) == HTTP.Messages.Response

  response = HTTP.request("GET", url)
  JSON3.read(String(response.body))

  HN.fetch_story(21676252)

  HN.average_score()

  HN.fetch_top_stories() |> first
  first(HN.fetch_top_stories())

  HN.fetch_top_stories() |> first |> HN.fetch_story

  HN.top_story_id()

  HN.top_story()

  HN.top_story_title()

  "John" |> HN.logx("Hello, {}")
  [1, 2, 3] |> HN.logx("Array size is {}", length)

  HN.average_score2()
  HN.average_score3()

  HN.check_hotness(10)

  xs = collect(1:10000)

  @btime HN.add1mul2v($xs)
  @btime HN.add1mul2($xs)


end
