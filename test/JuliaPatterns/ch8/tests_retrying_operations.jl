using Test
import JuliaStudy.JuliaPatterns.RetryingOperations as RO

@testset "Retrying Operations" begin
  # RO.do_something("John")
  # RO.do_something("John")

  # RO.do_something_more_robustly("John")

  # retry(RO.do_something, delays = fill(2.0, 3))("John")
  fill(2.0, 3)

  # retry(RO.do_something, delays = ExponentialBackOff(; n = 10))("John")
end

@testset "Choosing nothing over exceptions" begin
  @test match(r"\.com$", "google.com") |> typeof == RegexMatch
  @test match(r"\.com$", "w3.org") |> typeof == Nothing
end
