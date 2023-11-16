using Test
import JuliaStudy.JuliaPerformance.AnalyzingPerformance as AnaP

using Profile
using ProfileView
using BenchmarkTools
using TimerOutputs

@testset "Analyzing Performance" begin
  @time sqrt.(rand(1000))

  @time for i in 1:1000
    x = sin.(rand(1000))
  end

  @timev sqrt.(rand(1000))

  @time sqrt.(rand(1000)) |> sum
  sqrt.(rand(1000)) |> sum

  @elapsed sqrt.(rand(1000))

  @test @elapsed(sqrt.(rand(1000))) <= 10e-4

  AnaP.randmsq()
  @profile AnaP.randmsq()
  Profile.print()
  Profile.print(format = :flat)
  Profile.clear()

  ProfileView.view()

  AnaP.randmsq_timed()
  print_timer(AnaP.to)

  @benchmark sqrt.(rand(1000))
  @btime sqrt.(rand(1000))
  @btime mean(rand(1000))
end
